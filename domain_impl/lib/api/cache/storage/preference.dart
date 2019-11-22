import 'package:domain/api/cache/storage/delegate.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class _Preference<T> extends Delegate<T> {
  final SharedPreferences _preferences;
  final String _key;

  _Preference(this._preferences, this._key);
}

class PreferenceString extends _Preference<String> {
  PreferenceString(SharedPreferences preferences, String key)
      : super(preferences, key);

  @override
  Future<String> get() async {
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
  Future<int> get() async {
    return _preferences.getInt(_key);
  }

  @override
  Future set(value) {
    return _preferences.setInt(_key, value);
  }
}
