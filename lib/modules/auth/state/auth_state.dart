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

  Future<bool> getAuthSharedPrefs() async {
    final List results = await Future.wait([
      _authLocal.getTokenFromStorage(), // 0 - token
      _authLocal.getUserEmailFromStorage(), // 1 - email
      _authLocal.getUserIdFromStorage(), // 2 - id
    ]);
    authToken = results[0];
    userEmail = results[1];
    userId = results[2];
    return authToken is String && userEmail is String && userId is int;
  }

  Future<void> _setAuthSharedPrefs({
    @required String token,
    @required String email,
    @required int id,
  }) async {
    await Future.wait([
      _authLocal.setTokenToStorage(token),
      _authLocal.setUserEmailToStorage(email),
      _authLocal.setUserIdToStorage(id),
    ]);
    authToken = token;
    userEmail = email;
    userId = id;
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
        _setAuthSharedPrefs(token: token, email: email, id: id);

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
    _authLocal.deleteUserEmailFromStorage();
    _authLocal.deleteUserIdFromStorage();
    authToken = null;
    userEmail = null;
    userId = null;
  }
}
