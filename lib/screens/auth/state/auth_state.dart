import 'package:aurorafiles/store/app_state.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:mobx/mobx.dart';

import '../auth_repository.dart';

part 'auth_state.g.dart';

class AuthState = _AuthState with _$AuthState;

abstract class _AuthState with Store {
  final _repo = AuthRepository();
  final _appState = SingletonStore.instance;

  @observable
  bool isLoggingIn = false;

  final emailCtrl = TextEditingController();
  final passwordCtrl = TextEditingController();

  Future<void> onLogin(
      {bool isFormValid, Function onSuccess, Function onError}) async {
    if (isFormValid) {
      SystemChannels.textInput.invokeMethod('TextInput.hide');
      String email = emailCtrl.text;
      String password = passwordCtrl.text;

      try {
        isLoggingIn = true;
        final String token = await _repo.login(email, password);
        await _repo.setTokenToStorage(token);
        _appState.authToken = token;
        onSuccess();
      } catch (err) {
        onError(err is String ? err : err.toString());
      } finally {
        isLoggingIn = false;
      }
    }
  }

  void onLogout() {
    _repo.deleteTokenFromStorage();
    _appState.authToken = null;
  }
}
