import 'package:shared_preferences/shared_preferences.dart';

class AuthLocalStorage {

  final _hostKey = "host";

  Future<String?> getHostFromStorage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(_hostKey);
  }

  Future<bool> setHostToStorage(String? value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return value == null
        ? prefs.remove(_hostKey)
        : prefs.setString(_hostKey, value);
  }

  Future<bool> deleteHostFromStorage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.remove(_hostKey);
  }

  final _authTokenKey = "authToken";

  Future<String?> getTokenFromStorage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(_authTokenKey);
  }

  Future<bool> setTokenToStorage(String? value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return value == null
        ? prefs.remove(_authTokenKey)
        : prefs.setString(_authTokenKey, value);
  }

  Future<bool> deleteTokenFromStorage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.remove(_authTokenKey);
  }

  final _userEmailKey = "userEmail";

  Future<String?> getUserEmailFromStorage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(_userEmailKey);
  }

  Future<bool> setUserEmailToStorage(String? value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return value == null
        ? prefs.remove(_userEmailKey)
        : prefs.setString(_userEmailKey, value);
  }

  Future<bool> deleteUserEmailFromStorage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.remove(_userEmailKey);
  }

  final _userIdKey = "userId";

  Future<int?> getUserIdFromStorage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_userIdKey);
  }

  Future<bool> setUserIdToStorage(int? value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return value == null
        ? prefs.remove(_userIdKey)
        : prefs.setInt(_userIdKey, value);
  }

  Future<bool> deleteUserIdFromStorage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.remove(_userIdKey);
  }

  final _friendlyNameKey = "friendlyName";

  Future<String?> getFriendlyName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(_friendlyNameKey);
  }

  Future<bool> setFriendlyName(String? value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return value == null
        ? prefs.remove(_friendlyNameKey)
        : prefs.setString(_friendlyNameKey, value);
  }

  final _identityKey = "identity";

  Future<List<String>?> getIdentity() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_identityKey);
  }

  Future setIdentity(List<String>? value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return value == null
        ? prefs.remove(_identityKey)
        : prefs.setStringList(_identityKey, value);
  }

  final _lastEmailKey = "lastEmail";

  Future<String?> getLastEmail() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(_lastEmailKey);
  }

  Future<bool> setLastEmail(String? value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return value == null
        ? prefs.remove(_lastEmailKey)
        : prefs.setString(_lastEmailKey, value);
  }

  final _lastHostKey = "lastHost";

  Future<String?> getLastHost() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(_lastHostKey);
  }

  Future<bool> setLastHost(String? value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return value == null
        ? prefs.remove(_lastHostKey)
        : prefs.setString(_lastHostKey, value);
  }
}
