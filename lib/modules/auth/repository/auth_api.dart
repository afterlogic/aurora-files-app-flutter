import 'dart:convert';

import 'package:aurorafiles/config.dart';
import 'package:aurorafiles/models/api_body.dart';
import 'package:aurorafiles/modules/app_store.dart';
import 'package:aurorafiles/utils/api_utils.dart';
import 'package:aurorafiles/utils/custom_exception.dart';
import 'package:http/http.dart' as http;

class AuthApi {
  Future<String> autoDiscoverHostname(String domain) async {
    try {
      final url = "$AUTO_DISCOVER_URL?domain=$domain";
      final res = await http.get(url);
      final resBody = json.decode(res.body);
      return resBody["url"];
    } catch(err) {
      return null;
    }
  }

  Future<Map<String, dynamic>> login(String email, String password) async {
    final parameters =
        json.encode({"Login": email, "Password": password, "Pattern": ""});

    final body =
        new ApiBody(module: "Core", method: "Login", parameters: parameters)
            .toMap();

    final res = await http.post(AppStore.authState.apiUrl, body: body);

    final resBody = json.decode(res.body);
    if (resBody['Result'] != null && resBody['Result']['AuthToken'] is String) {
      return resBody;
    } if (resBody["ErrorCode"] == 108) {
      // the app is unavailable for this account, upgrade
      throw 108;
    } else {
      throw CustomException(getErrMsg(resBody));
    }
  }
}
