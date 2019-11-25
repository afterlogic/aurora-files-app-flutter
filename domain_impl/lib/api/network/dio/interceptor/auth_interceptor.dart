import 'package:dio/dio.dart';
import 'package:domain/api/cache/storage/user_storage_api.dart';
import 'package:domain/api/network/error/network_error.dart';

class AuthInterceptor extends Interceptor {
  Function onUnauthorized;
  final UserStorageApi _userStorageApi;

  AuthInterceptor(this._userStorageApi);

  @override
  Future onRequest(RequestOptions options) {
    addToken(options.headers, _userStorageApi);
    return super.onRequest(options);
  }

  @override
  Future onResponse(Response response) {
    return super.onResponse(response);
  }

  @override
  Future onError(DioError err) {
    if (err.error is NetworkError &&
        err.error.errorCase == NetworkErrorCase.Unauthorized) {
      if (onUnauthorized != null) {
        onUnauthorized();
      }
    }
    return super.onError(err);
  }

  static addToken(Map<String, dynamic> headers, UserStorageApi userStorageApi) {
    final token = userStorageApi.token.get();
    if (token != null) {
      headers["Authorization"] = "Bearer $token";
    }
  }
}
