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

  String hostName = 'http://test.afterlogic.com';

  String get apiUrl => '$hostName/?Api/';

  String authToken;
  int userId;
  String userEmail;

  @observable
  bool isLoggingIn = false;

  final emailCtrl = TextEditingController();
  final passwordCtrl = TextEditingController();

  Future<bool> initAuthSharedPrefs() async {
    final List results = await Future.wait([
      _authLocal.getTokenFromStorage(),
      _authLocal.getUserIdFromStorage(),
    ]);
    authToken = results[0];
    userId = results[1];
    return authToken is String && userId is int;
  }

  Future<void> onLogin(
      {bool isFormValid, Function onSuccess, Function onError}) async {
    if (isFormValid) {
      SystemChannels.textInput.invokeMethod('TextInput.hide');
      String email = emailCtrl.text;
      String password = passwordCtrl.text;

      try {
        isLoggingIn = true;
        final Map<String, dynamic> res = await _authApi.login(email, password);
        final String token = res['Result']['AuthToken'];
        final int id = res['AuthenticatedUserId'];

        await _authLocal.setTokenToStorage(token);
        await _authLocal.setUserIdToStorage(id);
        authToken = token;
        userId = id;
        onSuccess();
      } catch (err) {
        onError(err.toString());
      } finally {
        isLoggingIn = false;
      }
    }
  }

  void onLogout() {
    _authLocal.deleteTokenFromStorage();
    _authLocal.deleteUserIdFromStorage();
    authToken = null;
  }
}
