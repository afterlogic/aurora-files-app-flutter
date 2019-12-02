import 'package:dio/dio.dart';
import 'package:domain/api/cache/storage/user_storage_api.dart';
import 'package:domain/api/network/error/network_error.dart';

class AuthInterceptor extends Interceptor {
  Function onUnauthorized;
  final UserStorageApi _userStorageApi;

  AuthInterceptor(this._userStorageApi);

  @override
  Future onRequest(RequestOptions options) {
    options.headers[authorizationHeader] = token(_userStorageApi);
    return super.onRequest(options);
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

  static token(UserStorageApi userStorageApi) {
    final token = userStorageApi.token.toString();
    if (token != null) {
      return "Bearer $token";
    } else {
      return null;
    }
  }

  static int userId;
  static const authorizationHeader = "Authorization";
}
