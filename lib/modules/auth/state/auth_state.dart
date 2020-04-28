import 'dart:io';

import 'package:aurorafiles/error/api_error_code.dart';
import 'package:aurorafiles/modules/app_store.dart';
import 'package:aurorafiles/modules/auth/repository/auth_api.dart';
import 'package:aurorafiles/modules/auth/repository/auth_local_storage.dart';
import 'package:aurorafiles/modules/files/repository/mail_api.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobx/mobx.dart';

part 'auth_state.g.dart';

class AuthState = _AuthState with _$AuthState;

abstract class _AuthState with Store {
  final _authApi = AuthApi();
  final _mailApi = MailApi();
  final _authLocal = AuthLocalStorage();

  String hostName;

  String get apiUrl => '$hostName/?Api/';

  String authToken;
  int userId;
  String userEmail;
  String friendlyName;

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
    @required String host,
    @required String token,
    @required String email,
    @required int id,
  }) async {
    await Future.wait([
      _authLocal.setHostToStorage(host),
      _authLocal.setTokenToStorage(token),
      _authLocal.setUserEmailToStorage(email),
      _authLocal.setUserIdToStorage(id),
    ]);
    hostName = host;
    authToken = token;
    userEmail = email;
    userId = id;
  }

  Future successLogin() {
    return Future.wait([
      setAccount(),
      AppStore.settingsState.updateSettings(),
    ]);
  }

  Future setAccount() async {
    final account = await _mailApi.getAccounts();
    if (account.isNotEmpty) {
      await _authLocal.setFriendlyName(account.first.friendlyName);
      friendlyName = account.first.friendlyName;
    }
  }

  // returns true the host field needs to be revealed because auto discover was unsuccessful
  Future<bool> onLogin(
      {bool isFormValid,
      Function() onSuccess,
      Function() onTwoFactorAuth,
      Function() onShowUpgrade,
      Function(String) onError}) async {
    if (isFormValid) {
      SystemChannels.textInput.invokeMethod('TextInput.hide');
      String email = emailCtrl.text;
      String password = passwordCtrl.text;
      hostName = hostCtrl.text.startsWith("http")
          ? hostCtrl.text
          : "https://${hostCtrl.text}";

      isLoggingIn = true;
      // auto discover domain
      if (hostCtrl.text.isEmpty) {
        final splitEmail = email.split("@");
        final domain = splitEmail.last.trim();
        final autoDiscoveredHost = await _authApi.autoDiscoverHostname(domain);
        if (autoDiscoveredHost == null || autoDiscoveredHost.isEmpty) {
          isLoggingIn = false;
          return true;
        } else {
          hostName = autoDiscoveredHost;
        }
      }

      try {
        final Map<String, dynamic> res = await _authApi.login(email, password);
        if (res["Result"].containsKey("TwoFactorAuth")) {
          onTwoFactorAuth();
          isLoggingIn = false;
          return false;
        }
        final String token = res['Result']['AuthToken'];
        final int id = res['AuthenticatedUserId'];
        await _setAuthSharedPrefs(
            host: hostName, token: token, email: email, id: id);
        await successLogin();
        onSuccess();
      } catch (err) {
        isLoggingIn = false;
        if (err is SocketException && err.osError.errorCode == 7) {
          onError("\"$hostName\" is not a valid hostname");
        } else if (err == accessDenied) {
          onShowUpgrade();
        } else {
          onError(err.toString());
        }
      }
    }

    return false;
  }

  void onLogout() {
    AppStore.filesState.currentStorages = new List();
    _authLocal.deleteTokenFromStorage();
    _authLocal.deleteUserIdFromStorage();
    authToken = null;
    userId = null;
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
    final token = map["Result"]["AuthToken"];

    await _setAuthSharedPrefs(
      host: hostName,
      token: token,
      email: email,
      id: userId,
    );
    return true;
  }
}
