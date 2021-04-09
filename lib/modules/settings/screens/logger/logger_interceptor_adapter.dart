import 'package:aurora_logger/aurora_logger.dart';
import 'package:aurorafiles/http/interceptor.dart';

class LoggerInterceptorAdapter extends LoggerApiInterceptor {
  LoggerInterceptorAdapter() {
    WebMailApi.onResponse = (msg) {
      response(msg);
    };
    WebMailApi.onRequest = (msg) {
      request(msg);
    };
    WebMailApi.onError = (msg) {
      error(msg);
    };
  }
}
