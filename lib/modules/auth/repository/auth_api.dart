import 'dart:convert';

import 'package:aurorafiles/build_property.dart';
import 'package:aurorafiles/error/api_error_code.dart';
import 'package:aurorafiles/http/interceptor.dart';
import 'package:aurorafiles/models/api_body.dart';
import 'package:aurorafiles/modules/app_store.dart';
import 'package:aurorafiles/utils/api_utils.dart';
import 'package:aurorafiles/utils/custom_exception.dart';
import 'package:http/http.dart' as http;

import 'device_id_storage.dart';

class AuthApi {
  Future<Map<String, String>> deviceIdHeader() async {
    return {"X-DeviceId": await DeviceIdStorage.getDeviceId()};
  }

  Future<String?> autoDiscoverHostname(String email) async {
    try {
      final dogIndex = email.indexOf("@") + 1;

      final domain = email.substring(dogIndex);

      final url = BuildProperty.autodiscover_url
          .replaceFirst("{domain}", domain)
          .replaceFirst("{email}", email);

      final res = await http.get(Uri.parse(url));
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

    final res = await WebMailApi.request(
        AppStore.authState.apiUrl, body, await deviceIdHeader());

    final resBody = json.decode(res.body);
    if (resBody['Result'] != null &&
        resBody['Result']['TwoFactorAuth'] != null) {
      final twoFactor = resBody['Result']['TwoFactorAuth'];
      if (twoFactor == true) {
        throw RequestTwoFactor(
          true,
          false,
          false,
        );
      } else {
        throw RequestTwoFactor(
          twoFactor["HasAuthenticatorApp"] as bool,
          twoFactor["HasSecurityKey"] as bool,
          twoFactor["HasBackupCodes"] as bool,
        );
      }
    } else if (resBody['Result'] != null) {
      if (BuildProperty.supportAllowAccess &&
          resBody['Result']["AllowAccess"] != 1) {
        throw AllowAccess();
      }
      return resBody;
    }
    if (resBody["ErrorCode"] == accessDenied) {
      throw AllowAccess();
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
      "Code": pin,
      "Login": login,
      "Password": password,
    });

    final body = ApiBody(
            module: "TwoFactorAuth",
            method: "VerifyAuthenticatorAppCode",
            parameters: parameters)
        .toMap();

    final res = await WebMailApi.request(
        AppStore.authState.apiUrl, body, await deviceIdHeader());

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
      final body = ApiBody(
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
      final body = ApiBody(
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

  Future<SecurityKeyBegin> verifySecurityKeyBegin(
    String host,
    String login,
    String password,
  ) async {
    final request = ApiBody(
        module: "TwoFactorAuth",
        method: "VerifySecurityKeyBegin",
        parameters: jsonEncode({
          "Login": login,
          "Password": password,
        }));
    final response =
        await WebMailApi.request(host, request.toMap(), await deviceIdHeader());

    final res = json.decode(response.body);
    if (res is Map && res.containsKey("Result")) {
      final map = res["Result"]["publicKey"];
      return SecurityKeyBegin(
        host,
        (map["timeout"] as num).toDouble(),
        map["challenge"] as String,
        map["rpId"] as String,
        (map["allowCredentials"] as List)
            .map((e) => e["id"] as String)
            .toList(),
      );
    } else {
      throw CustomException(getErrMsg(res));
    }
  }

  Future<Map<String, dynamic>> verifySecurityKeyFinish(
    String host,
    String login,
    String password,
    Map attestation,
  ) async {
    final request = ApiBody(
        module: "TwoFactorAuth",
        method: "VerifySecurityKeyFinish",
        parameters: jsonEncode({
          "Login": login,
          "Password": password,
          "Attestation": attestation,
        }));
    final response =
        await WebMailApi.request(host, request.toMap(), await deviceIdHeader());
    final res = json.decode(response.body);
    if (res["Result"] is! Map ||
        !(res["Result"] as Map).containsKey("AuthToken")) {
      throw CustomException(getErrMsg(res));
    }
    final userId = res['AuthenticatedUserId'] as int;
    final token = res["Result"]["AuthToken"] as String;

    return {
      "userId": userId,
      "token": token,
      "hostname": host,
      "emailFromLogin": login,
    };
  }

  Future<Map<String, dynamic>> backupCode(
    String code,
    String login,
    String password,
  ) async {
    final parameters = json.encode({
      "BackupCode": code,
      "Login": login,
      "Password": password,
    });

    final body = ApiBody(
            module: "TwoFactorAuth",
            method: "VerifyBackupCode",
            parameters: parameters)
        .toMap();

    final res = await WebMailApi.request(
        AppStore.authState.apiUrl, body, await deviceIdHeader());

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

  Future saveDevice(
    String deviceId,
    String deviceName,
    String? token,
  ) async {
    final parameters = json.encode({
      "DeviceId": deviceId,
      "DeviceName": deviceName,
    });

    final body = ApiBody(
            module: "TwoFactorAuth",
            method: "SaveDevice",
            parameters: parameters)
        .toMap();

    try {
      final res = await WebMailApi.request(
          AppStore.authState.apiUrl, body, await deviceIdHeader(), token);
      final response = jsonDecode(res.body);

      print(response);
    } catch (err) {
      print("saveDevice ERROR: $err");
    }
  }

  Future trustDevice(
    String deviceId,
    String deviceName,
    String login,
    String password,
    String? token,
  ) async {
    final parameters = json.encode({
      "DeviceId": deviceId,
      "DeviceName": deviceName,
      "Login": login,
      "Password": password,
    });

    final body = ApiBody(
            module: "TwoFactorAuth",
            method: "TrustDevice",
            parameters: parameters)
        .toMap();

    final res = await WebMailApi.request(
        AppStore.authState.apiUrl, body, await deviceIdHeader(), token);
    final response = jsonDecode(res.body);

    print(response);
  }

  Future<int> getTwoFactorSettings() async {
    final body = ApiBody(
      module: "TwoFactorAuth",
      method: "GetSettings",
    ).toMap();

    final res = await WebMailApi.request(
        AppStore.authState.apiUrl, body, await deviceIdHeader());
    final map = json.decode(res.body);

    return (map["Result"]["TrustDevicesForDays"] as num).toInt();
  }

  void logout() async {
    final body = ApiBody(
      module: "Core",
      method: "Logout",
    ).toMap();

    final res = await WebMailApi.request(
      AppStore.authState.apiUrl,
      body,
    );
    final map = json.decode(res.body);

    print(map);
  }
}

class AllowAccess extends Error {}

class SecurityKeyBegin {
  final String host;
  final double timeout;
  final String challenge;
  final String rpId;
  final List<String> allowCredentials;

  SecurityKeyBegin(
    this.host,
    this.timeout,
    this.challenge,
    this.rpId,
    this.allowCredentials,
  );
}

class RequestTwoFactor extends Error {
  final bool hasAuthenticatorApp;
  final bool hasSecurityKey;
  final bool hasBackupCodes;

  RequestTwoFactor(
      this.hasAuthenticatorApp, this.hasSecurityKey, this.hasBackupCodes);
}
