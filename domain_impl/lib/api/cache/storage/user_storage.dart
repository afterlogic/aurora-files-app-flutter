import 'package:domain/api/cache/storage/delegate.dart';
import 'package:domain/api/cache/storage/user_storage_api.dart';
import 'package:domain_impl/api/cache/storage/preference.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserStorage implements UserStorageApi {
  final Delegate<String> host;
  final Delegate<String> token;
  final Delegate<String> userEmail;
  final Delegate<int> userId;
  final Delegate<bool> isDarkTheme;

  UserStorage(SharedPreferences _preference)
      : host = PreferenceString(_preference, "host"),
        token = PreferenceString(_preference, "authToken"),
        userEmail = PreferenceString(_preference, "userEmail"),
        userId = PreferenceInt(_preference, "userId"),
        isDarkTheme = PreferenceBool(_preference, "isDarkTheme");
}
