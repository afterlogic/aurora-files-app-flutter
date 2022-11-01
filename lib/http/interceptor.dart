import 'dart:convert';

import 'package:aurorafiles/error/api_error_code.dart';
import 'package:aurorafiles/modules/settings/repository/settings_local_storage.dart';
import 'package:http/http.dart' as http;

class WebMailApi {
  static Function(String)? onResponse;
  static Function(String)? onRequest;
  static Function(String)? onError;
  static Function? onLogout;
  static bool Function(String, String) isMethodEnable;

  static Future<http.Response> request(
    String url, [
    dynamic body,
    Map<String, String> headers,
    String token,
  ]) async {
    final logId = "MODULE: ${body['Module']}\nMETHOD: ${body['Method']}";
    _logRequest(logId, url, body);

    final enableOnServer = isMethodEnable(body['Module'], body['Method']);
    if (enableOnServer == false) {
      return http.Response(
        '{"ErrorMessage": "Method ${body['Module']} -> ${body['Method']} is not available on the server",'
        '"Module": "${body['Module']}",'
        '"Method": "${body['Method']}"}',
        methodNotFound,
        reasonPhrase:
            'Method ${body['Module']} -> ${body['Method']} is not available on the server',
      );
    }

    Map<String, String> _headers =
        token == null ? {} : {'Authorization': 'Bearer $token'};
    headers?.forEach((key, value) {
      _headers[key] = value;
    });

    final rawResponse =
        await http.post(Uri.parse(url), body: body, headers: _headers);
    final res = json.decode(rawResponse.body);
    _logResponse(logId, rawResponse.statusCode, rawResponse.body);

    if (res["ErrorCode"] == invalidEmailPassword /*102*/) {
      _logout();
    }
    if (res["ErrorCode"] == accessDenied /*108*/) {
      _logoutIfMethodEnable(body['Module'], body['Method']);
    }
    if (res["Result"] != null && (res["Result"] != false)) {
      return rawResponse;
    } else {
      _logError(logId, rawResponse.body);
      return rawResponse;
    }
  }

  static void _logRequest(String id, String url, dynamic body) {
    if (onRequest != null) {
      onRequest("$id\nURL: $url\nBODY: $body}");
    }
  }

  static Future<void> _logResponse(
      String id, int statusCode, String body) async {
    if (onResponse != null) {
      final showResponseBody =
          await SettingsLocalStorage().getShowResponseBody();
      onResponse(
          "$id\nSTATUS: $statusCode ${showResponseBody ? '\nBODY: $body' : ''}");
    }
  }

  static void _logError(String id, String body) {
    if (onError != null) {
      onError("$id\nBODY: $body}");
    }
  }

  static void _logout() {
    try {
      onLogout?.call();
    } catch (e) {
      print(e);
    }
  }

  static void _logoutIfMethodEnable(String module, String method) {
    final enable = isMethodEnable(module, method);
    if (enable) _logout();
  }
}
