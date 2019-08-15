import 'package:mobx/mobx.dart';

part 'app_state.g.dart';

class SingletonStore {
  static final AppState instance = new AppState();
}

class AppState = _AppState with _$AppState;

abstract class _AppState with Store {
  String hostName = 'http://test.afterlogic.com';

  String get apiUrl => '$hostName/?Api/';

  String authToken;
  int userId;
}
