import 'package:shared_preferences/shared_preferences.dart';

class AuthLocalStorage {
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

  // UserId
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
}
