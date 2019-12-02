import 'package:aurorafiles/di/di.dart';
import 'package:domain_impl/api/network/dio/interceptor/auth_interceptor.dart';

Map<String, String> getHeader() {
  return {AuthInterceptor.authorizationHeader: AuthInterceptor.token(DI.get())};
}
