import 'package:shared_preferences/shared_preferences.dart';

class AuthLocalStorage {
  // Token
  Future<String> getHostFromStorage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString("host");
  }

  Future<bool> setHostToStorage(String value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString("host", value);
  }

  Future<bool> deleteHostFromStorage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.remove("host");
  }

  // Token
  Future<String> getTokenFromStorage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString("authToken");
  }

  Future<bool> setTokenToStorage(String value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString("authToken", value);
  }

  Future<bool> deleteTokenFromStorage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.remove("authToken");
  }

  // User Email
  Future<String> getUserEmailFromStorage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString("userEmail");
  }

  Future<bool> setUserEmailToStorage(String value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString("userEmail", value);
  }

  Future<bool> deleteUserEmailFromStorage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.remove("userEmail");
  }

  // User Id
  Future<int> getUserIdFromStorage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getInt("userId");
  }

  Future<bool> setUserIdToStorage(int value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setInt("userId", value);
  }

  Future<bool> deleteUserIdFromStorage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.remove("userId");
  }

  Future<String> getFriendlyName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString("friendlyName");
  }

  Future<bool> setFriendlyName(String value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString("friendlyName", value);
  }

  Future setIdentity(List<String> identity) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setStringList("identity", identity);
  }

  Future<List<String>> getIdentity() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getStringList("identity");
  }

  final _lastEmailKey = "lastEmail";

  // User Id
  Future<String> getLastEmail() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(_lastEmailKey);
  }

  Future<bool> setLastEmail(String value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(_lastEmailKey, value);
  }

  final _lastHostKey = "lastHost";

  Future<String> getLastHost() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(_lastHostKey);
  }

  Future<bool> setLastHost(String value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(_lastHostKey, value);
  }
}
