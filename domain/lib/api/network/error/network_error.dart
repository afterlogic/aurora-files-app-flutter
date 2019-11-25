import 'package:domain/error/base_error.dart';

class NetworkError extends BaseError<NetworkErrorCase> {
  NetworkError(NetworkErrorCase errorCase) : super(errorCase, "");
}
enum NetworkErrorCase { Unauthorized, InvalidLogin, Undefined }
