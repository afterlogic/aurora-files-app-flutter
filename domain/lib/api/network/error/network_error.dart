import 'package:domain/error/base_error.dart';

class NetworkError extends BaseError<NetworkErrorCase> {
  final int code;

  NetworkError(this.code, NetworkErrorCase errorCase, [String message = ""])
      : super(errorCase, message);
}

enum NetworkErrorCase { Unauthorized, InvalidLogin, Undefined }
