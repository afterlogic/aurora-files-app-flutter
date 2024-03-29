import 'dart:io';

import 'package:aurora_ui_kit/components/dialogs/am_confirmation_dialog.dart';
import 'package:aurorafiles/database/pgp_key/pgp_key_dao.dart';
import 'package:aurorafiles/di/di.dart';
import 'package:aurorafiles/l10n/l10n.dart';
import 'package:aurorafiles/modules/app_store.dart';
import 'package:aurorafiles/modules/auth/repository/auth_api.dart';
import 'package:aurorafiles/modules/auth/repository/auth_local_storage.dart';
import 'package:aurorafiles/modules/auth/repository/device_id_storage.dart';
import 'package:aurorafiles/modules/files/repository/files_local_storage.dart';
import 'package:aurorafiles/modules/files/repository/mail_api.dart';
import 'package:aurorafiles/modules/settings/repository/encryption_local_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobx/mobx.dart';

part 'auth_state.g.dart';

class AuthState = _AuthState with _$AuthState;

abstract class _AuthState with Store {
  final _authApi = AuthApi();
  final _mailApi = MailApi();
  final _authLocal = AuthLocalStorage();
  final _filesLocal = FilesLocalStorage();

  String? hostName;

  String get apiUrl => '$hostName/?Api/';

  String? authToken;
  int? userId;
  String? userEmail;
  String? friendlyName;

  Future<String?> get lastEmail => _authLocal.getLastEmail();
  @observable
  bool isLoggingIn = false;

  final hostCtrl = TextEditingController();
  final emailCtrl = TextEditingController();
  final passwordCtrl = TextEditingController();

  Future<bool> getAuthSharedPrefs() async {
    userEmail = await _authLocal.getUserEmailFromStorage();
    authToken = await _authLocal.getTokenFromStorage();
    userId = await _authLocal.getUserIdFromStorage();
    hostName = await _authLocal.getHostFromStorage();
    friendlyName = await _authLocal.getFriendlyName();

    return hostName is String &&
        authToken is String &&
        userEmail is String &&
        userId is int;
  }

  Future<void> _setAuthSharedPrefs({
    required String? host,
    required String? token,
    required String? email,
    required int? id,
  }) async {
    await Future.wait([
      _authLocal.setHostToStorage(host),
      _authLocal.setTokenToStorage(token),
      _authLocal.setUserEmailToStorage(email),
      _authLocal.setUserIdToStorage(id),
      _authLocal.setLastHost(host),
      _authLocal.setLastEmail(email),
    ]);
    hostName = host;
    authToken = token;
    userEmail = email;
    userId = id;
  }

  Future successLogin() async {
    await AppStore.settingsState.updateAppData();
    return Future.wait([
      setIdentity(),
      setAccount(),
      AppStore.settingsState.updateEncryptionSettings(),
      setDevice(),
      AppStore.settingsState.getUserEncryptionKeys(),
      AppStore.filesState.onGetStorages(),
    ]);
  }

  Future<int> getTrustDevicesForDays() async {
    try {
      return await _authApi.getTwoFactorSettings();
    } catch (e) {
      return 0;
    }
  }

  Future setIdentity() async {
    final identity = await _authApi.getIdentity();
    await _authLocal.setIdentity(identity);
  }

  Future<List<String>?> getIdentity() {
    return _authLocal.getIdentity();
  }

  Future setAccount() async {
    try {
      final account = await _mailApi.getAccounts();
      if (account.isNotEmpty) {
        await _authLocal.setFriendlyName(account.first.friendlyName);
        friendlyName = account.first.friendlyName;
      }
    } catch (err) {
      print("setAccount ERROR: $err");
    }
  }

  // returns true the host field needs to be revealed because auto discover was unsuccessful
  Future<bool> onLogin({
    required BuildContext context,
    required bool isFormValid,
    required Function() onSuccess,
    required Function(RequestTwoFactor) onTwoFactorAuth,
    required Function(String? message) onShowUpgrade,
    required Function(String) onError,
  }) async {
    if (isFormValid) {
      SystemChannels.textInput.invokeMethod('TextInput.hide');
      String email = emailCtrl.text;
      String password = passwordCtrl.text;
      String host = hostCtrl.text;

      isLoggingIn = true;
      if (host.isEmpty) {
        if (email == await lastEmail) {
          final lastHost = await _authLocal.getLastHost();
          if (lastHost != null) host = lastHost;
        }
      }

      // auto discover domain
      final autoDiscoveredHost = await _authApi.autoDiscoverHostname(email);
      if (autoDiscoveredHost?.isNotEmpty == true) {
        if (host != autoDiscoveredHost) {
          host = autoDiscoveredHost ?? '';
        }
      }
      if (host.isEmpty) {
        isLoggingIn = false;
        return true;
      }

      host = host.startsWith("http") ? host : "https://$host";
      hostName = host;
      try {
        final Map<String, dynamic> res = await _authApi.login(email, password);
        final String token = res['Result']['AuthToken'];
        final int id = res['AuthenticatedUserId'];
        final oldUserId = await _authLocal.getUserIdFromStorage();
        if (oldUserId != null && oldUserId != id) {
          final s = context.l10n;
          final result = await AMConfirmationDialog.show(
            context,
            s.clear_cache,
            s.clear_cache_during_login,
            s.clear,
            s.cancel,
          );
          if (result == true) {
            await _clearCachedData();
          } else {
            isLoggingIn = false;
            return false;
            // throw s.clear_cache_during_login;
          }
        }
        await _setAuthSharedPrefs(
            host: host, token: token, email: email, id: id);
        await successLogin();
        onSuccess();
      } catch (err) {
        isLoggingIn = false;
        if (err is RequestTwoFactor) {
          onTwoFactorAuth(err);
        } else if (err is SocketException && err.osError?.errorCode == 7) {
          onError("\"$host\" is not a valid hostname");
        } else if (err is AllowAccess) {
          onShowUpgrade(null);
        } else {
          onError(err.toString());
        }
      }
    }

    return false;
  }

  void onLogout([bool clearCache = false]) {
    try {
      AppStore.filesState.currentStorages = [];
    } catch (err) {
      print(err);
    }
    _authApi.logout();
    _authLocal.deleteTokenFromStorage();
    if (clearCache) {
      _clearCachedData();
    }
    authToken = null;
    userId = null;
    EncryptionLocalStorage.instance.setStorePasswordStorage(false);
  }

  Future<void> _clearCachedData() async {
    await _authLocal.deleteUserIdFromStorage();
    _clearPgpKeys();
    await AppStore.filesState.deleteAllOfflineFiles();
    await _filesLocal.deleteFilesFromCache(deleteCachedImages: true);
    await _filesLocal.deleteFilesFromCache(deleteCachedImages: false);
  }

  void _clearPgpKeys() {
    PgpKeyDao pgpKeyDao = DI.instance.get();
    pgpKeyDao.clear();
  }

  Future<bool> twoFactorAuth(String pin) async {
    String email = emailCtrl.text;
    String password = passwordCtrl.text;
    SystemChannels.textInput.invokeMethod('TextInput.hide');
    final map = await _authApi.verifyPin(
      pin,
      email,
      password,
    );
    if (map["Result"] is! Map || !map["Result"].containsKey("AuthToken")) {
      return false;
    }
    final userId = map['AuthenticatedUserId'];
    final String? token = map["Result"]["AuthToken"];

    await _setAuthSharedPrefs(
      host: hostName,
      token: token,
      email: email,
      id: userId,
    );
    return true;
  }

  Future initUser(Map<String, dynamic> map) async {
    await _setAuthSharedPrefs(
      host: map["hostname"],
      token: map["token"],
      email: map["emailFromLogin"],
      id: map["userId"],
    );
  }

  Future<bool> backupCodeAuth(String pin) async {
    String email = emailCtrl.text;
    String password = passwordCtrl.text;
    SystemChannels.textInput.invokeMethod('TextInput.hide');
    final map = await _authApi.backupCode(
      pin,
      email,
      password,
    );
    if (map["Result"] is! Map || !map["Result"].containsKey("AuthToken")) {
      return false;
    }
    final userId = map['AuthenticatedUserId'];
    final token = map["Result"]["AuthToken"];

    await _setAuthSharedPrefs(
      host: hostName,
      token: token,
      email: email,
      id: userId,
    );
    return true;
  }

  Future<void> setDevice() async {
    final deviceId = await DeviceIdStorage.getDeviceId();
    final deviceName = await DeviceIdStorage.getDeviceName();
    await _authApi.saveDevice(deviceId, deviceName, authToken);
  }
}
