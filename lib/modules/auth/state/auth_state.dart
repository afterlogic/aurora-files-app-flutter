import 'dart:io';

import 'package:aurorafiles/di/di.dart';
import 'package:aurorafiles/error/api_error_code.dart';
import 'package:aurorafiles/modules/app_store.dart';
import 'package:dio/dio.dart';
import 'package:domain/api/cache/storage/user_storage_api.dart';
import 'package:domain/api/network/auth_network_api.dart';
import 'package:domain/model/network/auth/auth_request.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobx/mobx.dart';

part 'auth_state.g.dart';

class AuthState = _AuthState with _$AuthState;

abstract class _AuthState with Store {
  final AuthNetworkApi _authApi = DI.get();
  final UserStorageApi _authLocal = DI.get();
  final Dio _dio = DI.get();

  String get hostName => _authLocal.host.toString();

  String get apiUrl => '$hostName/?Api/';

  String get userEmail=> _authLocal.userEmail.toString();

  @observable
  bool isLoggingIn = false;

  final hostCtrl = TextEditingController();
  final emailCtrl = TextEditingController();
  final passwordCtrl = TextEditingController();

  Future<bool> getAuthSharedPrefs() async {
    final authToken = await _authLocal.token.get();
    return authToken != null;
  }

  Future<void> _setAuthSharedPrefs({
    @required String host,
    @required String token,
    @required String email,
  }) async {
    await Future.wait([
      _authLocal.host.set(host),
      _authLocal.token.set(token),
      _authLocal.userEmail.set(email),
    ]);
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
      var hostName = hostCtrl.text.startsWith("http")
          ? hostCtrl.text
          : "https://${hostCtrl.text}";

      isLoggingIn = true;
      // auto discover domain
      if (hostCtrl.text.isEmpty) {
        final splitEmail = email.split("@");
        final domain = splitEmail.last.trim();
        final autoDiscoveredHost = await _authApi.getHostname(domain);
        if (autoDiscoveredHost == null || autoDiscoveredHost.isEmpty) {
          isLoggingIn = false;
          return true;
        } else {
          hostName = autoDiscoveredHost;
        }
      }

      try {
        _dio.options.baseUrl = hostName;
        _authLocal.host.set(hostName);
        final authResponse = await _authApi.login(AuthRequest(email, password));
        await _setAuthSharedPrefs(
            host: hostName, token: authResponse.authToken, email: email);
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
    _authLocal.token.set(null);
    _authLocal.userId.set(null);
  }
}
