import 'package:dio/dio.dart';
import 'package:domain/api/network/error/network_error.dart';
import 'package:domain_impl/api/network/error_code.dart';

class ConvertResponse extends Interceptor {
  @override
  Future onResponse(Response response) {
    if (response.data is Map) {
      if (response.statusCode != 200) {
        throw NetworkError(NetworkErrorCase.Undefined);
      }
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
      response.data = response.data["Result"];
    }
    return super.onResponse(response);
  }
}
