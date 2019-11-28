import 'package:dio/dio.dart';
import 'package:domain/api/cache/storage/user_storage_api.dart';

import 'interceptor/auth_interceptor.dart';
import 'interceptor/convert_response_interceptor.dart';

class DioInstance {
  static Dio create(
    AuthInterceptor authInterceptor,
    UserStorageApi userStorage,
  ) {
    final dio = Dio(
      BaseOptions(
        baseUrl: userStorage.host.toString() ?? "",
        contentType: contentType,
      ),
    );
    dio.interceptors.add(authInterceptor);
    dio.interceptors.add(ConvertResponse());
    dio.interceptors.add(LogInterceptor(
      responseBody: true,
      requestHeader: false,
      responseHeader: false,
    ));
    return dio;
  }

  static const contentType = "application/x-www-form-urlencoded";
}
