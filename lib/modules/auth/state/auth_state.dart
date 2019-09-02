import 'package:aurorafiles/modules/auth/repository/auth_api.dart';
import 'package:aurorafiles/modules/auth/repository/auth_local_storage.dart';
import 'package:aurorafiles/store/app_state.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:mobx/mobx.dart';

part 'auth_state.g.dart';

class AuthState = _AuthState with _$AuthState;

abstract class _AuthState with Store {
  final _authApi = AuthApi();
  final _authLocal = AuthLocalStorage();
  final _appState = SingletonStore.instance;

  @observable
  bool isLoggingIn = false;

  final emailCtrl = TextEditingController();
  final passwordCtrl = TextEditingController();

  Future<bool> initSharedPrefs() async {
    final List results = await Future.wait([
      _authLocal.getTokenFromStorage(),
      _authLocal.getUserIdFromStorage(),
    ]);
    _appState.authToken = results[0];
    _appState.userId = results[1];
    return _appState.authToken is String && _appState.userId is int;
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
        final int userId = res['AuthenticatedUserId'];

        await _authLocal.setTokenToStorage(token);
        await _authLocal.setUserIdToStorage(userId);
        _appState.authToken = token;
        _appState.userId = userId;
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
    _appState.authToken = null;
  }
}
