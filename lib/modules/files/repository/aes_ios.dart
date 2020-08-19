import 'dart:io';
import 'dart:typed_data';

import 'package:crypto_stream/crypto_plugin.dart';
import 'package:crypto_stream/error/crypto_exception.dart';
import 'package:flutter/services.dart';

final channel=MethodChannel("ios_aes_crypt");
class IosAes extends Aes {
  Future<dynamic> method(String method, List arg) async {
    if(!Platform.isIOS){
      return super.method(method, arg);
    }
    try {
      return await channel.invokeMethod(
        method,
        arg,
      );
    } catch (e, stack) {
      if (e is PlatformException) {
        switch (e.code) {
          case "0":
            throw PgpSignError(e.code, e, stack);
          case "1":
            throw PgpInputError(e.code, e, stack);
          default:
            throw CryptoException("", e, stack);
        }
      }
      throw CryptoException("", e, stack);
    }
  }


}