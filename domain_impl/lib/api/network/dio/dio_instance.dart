import 'package:dio/dio.dart';

import 'interceptor/auth_interceptor.dart';
import 'interceptor/convert_response_interceptor.dart';

class DioInstance {
  static Dio create(
    AuthInterceptor authInterceptor,
  ) {
    final dio = Dio(
      BaseOptions(
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
