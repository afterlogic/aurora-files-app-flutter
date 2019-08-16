import 'dart:convert';

import 'package:aurorafiles/models/api_body.dart';
import 'package:aurorafiles/store/app_state.dart';
import 'package:aurorafiles/utils/api_utils.dart';
import 'package:aurorafiles/utils/custom_exception.dart';
import 'package:http/http.dart' as http;

class AuthApi {
  final String apiUrl = SingletonStore.instance.apiUrl;

  Future<Map<String, dynamic>> login(String email, String password) async {
    final parameters =
        json.encode({"Login": email, "Password": password, "Pattern": ""});

    final body =
        new ApiBody(module: "Core", method: "Login", parameters: parameters)
            .toMap();

    final res = await http.post(apiUrl, body: body);

    final resBody = json.decode(res.body);
    if (resBody['Result'] != null && resBody['Result']['AuthToken'] is String) {
      return resBody;
    } else {
      throw CustomException(getErrMsg(resBody));
    }
  }
}
