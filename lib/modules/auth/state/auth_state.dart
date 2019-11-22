import 'dart:io';

import 'package:aurorafiles/error/api_error_code.dart';
import 'package:aurorafiles/modules/app_store.dart';
import 'package:aurorafiles/modules/auth/repository/auth_api.dart';
import 'package:aurorafiles/modules/auth/repository/auth_local_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobx/mobx.dart';

part 'auth_state.g.dart';

class AuthState = _AuthState with _$AuthState;

abstract class _AuthState with Store {
  final _authApi = AuthApi();
  final _authLocal = AuthLocalStorage();

  String hostName;

  String get apiUrl => '$hostName/?Api/';

  String authToken;
  int userId;
  String userEmail;

  @observable
  bool isLoggingIn = false;

  final hostCtrl = TextEditingController();
  final emailCtrl = TextEditingController();
  final passwordCtrl = TextEditingController();

  Future<bool> getAuthSharedPrefs() async {
    userEmail = await _authLocal.getUserEmail();
    authToken = await _authLocal.getToken();
    userId = await _authLocal.getUserId();
    hostName = await _authLocal.getHost();
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
      _authLocal.setHost(host),
      _authLocal.setToken(token),
      _authLocal.setUserEmail(email),
      _authLocal.setUserId(id),
    ]);
    hostName = host;
    authToken = token;
    userEmail = email;
    userId = id;
  }

  // returns true the host field needs to be revealed because auto discover was unsuccessful
  Future<bool> onLogin(
      {bool isFormValid,
      Function() onSuccess,
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
        final String token = res['Result']['AuthToken'];
        final int id = res['AuthenticatedUserId'];
        await _setAuthSharedPrefs(
            host: hostName, token: token, email: email, id: id);
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
    _authLocal.setToken(null);
    _authLocal.setUserId(null);
    authToken = null;
    userId = null;
  }
}
