import 'package:flutter/services.dart';

import '../error/cryptor_exception.dart';

const _cryptPluginChannel = const MethodChannel("crypto_plugin");

Future<dynamic> _invokeMethod(_EncapsulateMethod _invokeMethod) async {
  try {
    return await _cryptPluginChannel.invokeMethod(
      _invokeMethod.method,
      _invokeMethod.parameters,
    );
  } catch (e, stack) {
    throw CryptException("", e, stack);
  }
}

class _EncapsulateMethod {
  final String method;
  final List<dynamic> parameters;

  _EncapsulateMethod(this.method, this.parameters);
}

abstract class Crypt {
  Future<dynamic> invokeMethod(String method, List parameters) async {
    return await _invokeMethod(
      _EncapsulateMethod(
        method,
        parameters,
      ),
    );
  }
}
