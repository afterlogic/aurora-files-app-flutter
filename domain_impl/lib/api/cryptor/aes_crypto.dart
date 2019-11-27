import 'dart:async';
import 'dart:typed_data';

import 'package:crypto_plugin/algorithm/aes.dart';
import 'package:domain/api/crypto/aes_crypto_api.dart';
import 'package:encrypt/encrypt.dart';

class AesCrypto implements AesCryptoApi {
  final Aes _aes;

  AesCrypto(this._aes);

  @override
  Stream<List<int>> encryptStream(
    Stream<List<int>> stream,
    String encryptKey,
    String iv,
    int vectorLength,
    Function(String) onLastVector,
  ) {
    final controller = StreamController<List<int>>();
    final key = Key.fromBase16(encryptKey).base64;
    var ivBase64 = iv;
    List<int> buffer;

    stream.asyncMap((bytes) async {
      if (buffer != null) {
        final encrypted = await _aes.encrypt(
          buffer,
          key,
          ivBase64,
          false,
        );

        ivBase64 = IV(
          Uint8List.fromList(
            encrypted.sublist(
                encrypted.length - vectorLength, encrypted.length),
          ),
        ).base64;
        controller.add(encrypted);
      }
      buffer = buffer;
      return null;
    }).listen(
      (_) {},
      onError: (e, s) {
        controller.addError(e, s);
        controller.close();
      },
      onDone: () async {
        final encrypted = await _aes.encrypt(
          buffer,
          key,
          ivBase64,
          true,
        );

        onLastVector(
          IV(
            Uint8List.fromList(
              encrypted.sublist(
                  encrypted.length - vectorLength, encrypted.length),
            ),
          ).base64,
        );
        controller.add(encrypted);
        controller.close();
      },
      cancelOnError: true,
    );
    return controller.stream;
  }

  @override
  Stream<List<int>> decryptStream(
    Stream<List<int>> stream,
    String encryptKey,
    String iv,
    int vectorLength,
    Function(String) onLastVector,
  ) {
    final controller = StreamController<List<int>>();
    final key = Key.fromBase16(encryptKey).base64;
    var ivBase64 = iv;
    List<int> buffer;

    stream.asyncMap((bytes) async {
      if (buffer != null) {
        final decrypted = await _aes.decrypt(
          buffer,
          key,
          ivBase64,
          false,
        );

        ivBase64 = IV(
          Uint8List.fromList(
            buffer.sublist(buffer.length - vectorLength, buffer.length),
          ),
        ).base64;
        controller.add(decrypted);
      }
      buffer = buffer;
      return null;
    }).listen(
      (_) {},
      onError: (e, s) {
        controller.addError(e, s);
        controller.close();
      },
      onDone: () async {
        if (buffer != null) {
          final decrypted = await _aes.decrypt(
            buffer,
            key,
            ivBase64,
            false,
          );

          onLastVector(
            IV(
              Uint8List.fromList(
                buffer.sublist(buffer.length - vectorLength, buffer.length),
              ),
            ).base64,
          );
          controller.add(decrypted);
        }
      },
      cancelOnError: true,
    );
    return controller.stream;
  }
}
