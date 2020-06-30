import 'dart:convert';

import 'package:aurorafiles/build_property.dart';
import 'package:aurorafiles/error/api_error_code.dart';
import 'package:aurorafiles/http/interceptor.dart';
import 'package:aurorafiles/models/api_body.dart';
import 'package:aurorafiles/modules/app_store.dart';
import 'package:aurorafiles/utils/api_utils.dart';
import 'package:aurorafiles/utils/custom_exception.dart';
import 'package:http/http.dart' as http;

class AuthApi {
  Future<String> autoDiscoverHostname(String email) async {
    try {
      final dogIndex = email.indexOf("@") + 1;

      final domain = email.substring(dogIndex);

      final url = BuildProperty.autodiscover_url
          .replaceFirst("{domain}", domain)
          .replaceFirst("{email}", email);

      final res = await http.get(url);
      final resBody = json.decode(res.body);
      return resBody["url"];
    } catch (err) {
      return null;
    }
  }

  Future<Map<String, dynamic>> login(String email, String password) async {
    final parameters =
        json.encode({"Login": email, "Password": password, "Pattern": ""});

    final body = ApiBody(
      module: "Core",
      method: "Login",
      parameters: parameters,
    ).toMap();

    final res = await WebMailApi.request(AppStore.authState.apiUrl, body);

    final resBody = json.decode(res.body);

    if (resBody['Result'] != null) {
      if (resBody['Result']["AllowAccess"] != 1) {
        throw AllowAccess();
      }
      return resBody;
    }
    if (resBody["ErrorCode"] == accessDenied) {
      // the app is unavailable for this account, upgrade
      throw accessDenied;
    } else {
      throw CustomException(getErrMsg(resBody));
    }
  }

  Future<Map<String, dynamic>> verifyPin(
    String pin,
    String login,
    String password,
  ) async {
    final parameters = json.encode({
      "Pin": pin,
      "Login": login,
      "Password": password,
    });

    final body = new ApiBody(
            module: "TwoFactorAuth",
            method: "VerifyPin",
            parameters: parameters)
        .toMap();

    final res = await WebMailApi.request(AppStore.authState.apiUrl, body);

    final resBody = json.decode(res.body);
    if (resBody['Result'] != null) {
      return resBody;
    }
    if (resBody["ErrorCode"] == accessDenied) {
      // the app is unavailable for this account, upgrade
      throw accessDenied;
    } else {
      throw CustomException(getErrMsg(resBody));
    }
  }

  Future<List<String>> getIdentity() async {
    final emails = <String>[];

    try {
      final body = new ApiBody(
        module: "Mail",
        method: "GetIdentities",
      );

      final res = await sendRequest(body);

      if (res["Result"] is List) {
        res["Result"].forEach((e) {
          emails.add(e["Email"]);
        });
      }
    } catch (e) {
      print(e);
    }

    try {
      final body = new ApiBody(
        module: "CpanelIntegrator",
        method: "GetAliases",
      );

      final res = await sendRequest(body);

      if (res["Result"] is Map) {
        res["Result"]["ObjAliases"].forEach((e) {
          emails.add(e["Email"]);
        });
      }
    } catch (e) {
      print(e);
    }
    return emails;
  }
}

class AllowAccess extends Error {}
