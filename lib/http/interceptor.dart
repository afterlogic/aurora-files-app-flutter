import 'dart:convert';

import 'package:http/http.dart' as http;

class WebMailApi {
  static Function(String) onResponse;
  static Function(String) onRequest;
  static Function(String) onError;
  static Function onLogout;

  static Future<http.Response> request(String url,
      [dynamic body, Map<String, String> headers, String token]) async {
    if (onRequest != null) onRequest("URL:$url\nBODY:$body");
    Map<String, String> _headers =
        token == null ? {} : {'Authorization': 'Bearer $token'};
    headers?.forEach((key, value) {
      _headers[key] = value;
    });
    final rawResponse = await http.post(url, body: body, headers: _headers);
    final res = json.decode(rawResponse.body);

    if (res["ErrorCode"] == 108) {
      try {
        onLogout?.call();
      } catch (e) {
        print(e);
      }
    }
    if (res["Result"] != null && (res["Result"] != false)) {
      return rawResponse;
    } else {
      onError.call("${rawResponse.body}");
      return rawResponse;
    }
  }
}
