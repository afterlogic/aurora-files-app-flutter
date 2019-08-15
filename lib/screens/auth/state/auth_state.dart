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

  Future<bool> initSharedPrefs() async {
    final List results = await Future.wait([
      _repo.getTokenFromStorage(),
      _repo.getUserIdFromStorage(),
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
        final Map<String, dynamic> res = await _repo.login(email, password);
        final String token = res['Result']['AuthToken'];
        final int userId = res['AuthenticatedUserId'];

        await _repo.setTokenToStorage(token);
        await _repo.setUserIdToStorage(userId);
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
    _repo.deleteTokenFromStorage();
    _repo.deleteUserIdFromStorage();
    _appState.authToken = null;
  }
}
