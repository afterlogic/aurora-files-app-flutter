import 'dart:convert';

import 'package:http/http.dart' as http;

class WebMailApi {
  static Function(String) onRequest;
  static Function(String) onError;

  static Future<http.Response> request(String url,
      [dynamic body, Map<String, String> headers]) async {
    if (onRequest != null) onRequest("URL:$url\nBODY:$body");
    final rawResponse = await http.post(url, body: body, headers: headers);
    final res = json.decode(rawResponse.body);

    if (res["Result"] != null && (res["Result"] != false)) {
      return rawResponse;
    } else {
      if (onError != null) onError("${rawResponse.body}");
      return rawResponse;
    }
  }
}
