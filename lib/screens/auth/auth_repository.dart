import 'dart:convert';

import 'package:aurorafiles/store/app_state.dart';
import 'package:aurorafiles/utils/get_error_message.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthRepository {
  final String apiUrl = SingletonStore.instance.apiUrl;

  Future<String> login(String email, String password) async {
    final parameters =
        json.encode({"Login": email, "Password": password, "Pattern": ""});

    final res = await http.post(apiUrl,
        body: {'Module': 'Core', 'Method': 'Login', 'Parameters': parameters});

    final resBody = json.decode(res.body);
    if (resBody['Result'] != null && resBody['Result']['AuthToken'] is String) {
      return resBody['Result']['AuthToken'];
    } else {
      throw Exception(getErrMsgFromCode(resBody["ErrorCode"]));
    }
  }

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
}
