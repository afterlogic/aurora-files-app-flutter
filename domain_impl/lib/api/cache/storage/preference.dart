import 'package:domain/api/cache/storage/delegate.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class _Preference<T> extends Delegate<T> {
  final SharedPreferences _preferences;
  final String _key;

  _Preference(this._preferences, this._key);

  @override
  Future clear() {
    return _preferences.remove(_key);
  }

  @override
  String toString() {
    return _preferences.get(_key);
  }
}

class PreferenceString extends _Preference<String> {
  PreferenceString(SharedPreferences preferences, String key)
      : super(preferences, key);

  @override
  String get() {
    return _preferences.getString(_key);
  }

  @override
  Future set(value) {
    return _preferences.setString(_key, value);
  }
}

class PreferenceInt extends _Preference<int> {
  PreferenceInt(SharedPreferences preferences, String key)
      : super(preferences, key);

  @override
  int get() {
    return _preferences.getInt(_key);
  }

  @override
  Future set(value) {
    return _preferences.setInt(_key, value);
  }
}

class PreferenceBool extends _Preference<bool> {
  PreferenceBool(SharedPreferences preferences, String key)
      : super(preferences, key);

  @override
  bool get() {
    return _preferences.getBool(_key);
  }

  @override
  Future set(value) {
    return _preferences.setBool(_key, value);
  }
}
