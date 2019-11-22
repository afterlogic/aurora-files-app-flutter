import 'package:shared_preferences/shared_preferences.dart';

class AuthLocalStorage {
  // Token
  Future<String> getHost() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString("host");
  }

  Future<bool> setHost(String value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString("host", value);
  }

  // Token
  Future<String> getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString("authToken");
  }

  Future<bool> setToken(String value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString("authToken", value);
  }

  // User Email
  Future<String> getUserEmail() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString("userEmail");
  }

  Future<bool> setUserEmail(String value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString("userEmail", value);
  }

  // User Id
  Future<int> getUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getInt("userId");
  }

  Future<bool> setUserId(int value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setInt("userId", value);
  }
}
