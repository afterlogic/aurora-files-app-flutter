import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:domain/api/network/error/network_error.dart';
import 'package:domain/error/error_code.dart';
import 'package:domain_impl/api/network/util/map_util.dart';

class ConvertResponse extends Interceptor {
  @override
  Future onResponse(Response response) {
    if (response.statusCode != 200) {
      throw NetworkError(null, NetworkErrorCase.Undefined);
    }

    Map data;
    if (response.data is Map) {
      data = response.data;
    } else {
      data = json.decode(response.data);
    }

    final error = data["ErrorCode"];
    if (error != null) {
      switch (error) {
        case ErrorCode.invalidEmailPassword:
          throw NetworkError(error, NetworkErrorCase.InvalidLogin);
        case ErrorCode.invalidToken:
          throw NetworkError(error, NetworkErrorCase.Unauthorized);
        default:
          throw NetworkError(
              error, NetworkErrorCase.Undefined, ErrorCode.message(error));
      }
    }

    if (data.containsKey("Result")) {
      final userId = data["AuthenticatedUserId"];
      response.data = _keysToLowerCase(data["Result"]..["userId"] = userId);
    } else {
      response.data = _keysToLowerCase(data);
    }

    return super.onResponse(response);
  }

  dynamic _keysToLowerCase(dynamic map) {
    if (map is Map<String, dynamic>) {
      return keysToLowerCase(map);
    }
    if (map is List) {
      return map.map((item) => _keysToLowerCase(item)).toList();
    } else {
      return map;
    }
  }
}
