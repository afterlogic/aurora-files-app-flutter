import 'package:dio/dio.dart';
import 'package:domain/api/network/error/network_error.dart';
import 'package:domain_impl/api/network/util/error_code.dart';
import 'package:domain_impl/api/network/util/map_util.dart';

class ConvertResponse extends Interceptor {
  @override
  Future onResponse(Response response) {
    if (response.statusCode != 200) {
      throw NetworkError(NetworkErrorCase.Undefined);
    }
    if (response.data is Map) {
      final error = response.data["ErrorCode"];
      if (error != null) {
        switch (error) {
          case ErrorCode.invalidEmailPassword:
            throw NetworkError(NetworkErrorCase.InvalidLogin);
          case ErrorCode.invalidToken:
            throw NetworkError(NetworkErrorCase.Unauthorized);
          default:
            throw NetworkError(NetworkErrorCase.Undefined);
        }
      }

      if (response.data.containsKey("Result")) {
        response.data = _keysToLowerCase(response.data["Result"]);
      } else {
        response.data = _keysToLowerCase(response.data);
      }
    }
    return super.onResponse(response);
  }

  dynamic _keysToLowerCase(dynamic map) {
    if (map is Map<String, dynamic>) {
      return keysToLowerCase(map);
    } else {
      return map;
    }
  }
}
