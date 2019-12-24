import 'dart:io';
import 'dart:typed_data';

import 'crypt.dart';

class Pgp extends Crypt {

  Future stop() async {
    await invokeMethod(
      "$algorithm.stop",
      [],
    );
  }

  Future<Progress> getProgress() async {
    if (Platform.isIOS) return Progress(1, -1);

    final result = await invokeMethod(
      "$algorithm.getProgress",
      [],
    );
    if (result is List) {
      final list = List<int>.from(result);
      return Progress(list[0], list[1]);
    } else {
      return null;
    }
  }

  Future setTempFile(File temp) async {
    if (Platform.isIOS) return;

    await invokeMethod(
      "$algorithm.setTempFile",
      [temp?.path],
    );
  }

  Future setPrivateKey(
    String key,
  ) async {
    await invokeMethod(
      "$algorithm.setPrivateKey",
      [key],
    );
  }

  Future setPublicKey(String key) async {
    await invokeMethod(
      "$algorithm.setPublicKey",
      [key],
    );
  }

  Future<List<int>> decryptBytes(
      Uint8List encryptedBytes, String password) async {
    final result = await invokeMethod(
      "$algorithm.decryptBytes",
      [encryptedBytes, password],
    );
    return List<int>.from(result);
  }

  Future decryptFile(File inputFile, File outputFile, String password) async {
    if (Platform.isIOS) {
      await outputFile.writeAsBytes(
        await decryptBytes(
          await inputFile.readAsBytes(),
          password,
        ),
      );
      return;
    }
    await invokeMethod(
      "$algorithm.decryptFile",
      [inputFile.path, outputFile.path, password],
    );
  }

  Future<List<int>> encryptBytes(Uint8List messageBytes) async {
    final result = await invokeMethod(
      "$algorithm.encryptBytes",
      [messageBytes],
    );
    return List<int>.from(result);
  }

  Future encryptFile(File inputFile, File outputFile) async {
    if (Platform.isIOS) {
      await outputFile.writeAsBytes(
        List<int>.from(
          await encryptBytes(
            await inputFile.readAsBytes(),
          ),
        ),
      );
      return;
    }
    await invokeMethod(
      "$algorithm.encryptFile",
      [inputFile.path, outputFile.path],
    );
  }

  static const algorithm = "pgp";

  Future<KeyDescription> getKeyDescription(String key) async {
    final result = await invokeMethod(
      "$algorithm.getKeyDescription",
      [key],
    );
    if (result is List) {
      return KeyDescription(List<String>.from(result[0]), result[1]);
    } else {
      return null;
    }
  }

  Future<KeyPair> createKeys(int length, String email, String password) async {
    final result = await invokeMethod(
      "$algorithm.createKeys",
      [length, email, password],
    );
    if (result is List) {
      return KeyPair(result[0], result[1]);
    } else {
      return null;
    }
  }
}

class Progress {
  final int total;
  final int current;

  Progress(this.total, this.current);

  @override
  String toString() {
    if (total != null && current != null) {
      return "Progress: " + (current / total).toString();
    }
    return super.toString();
  }
}

class KeyDescription {
  final List<String> email;
  final int length;

  KeyDescription(this.email, this.length);
}

class KeyPair {
  final String public;
  final String secret;

  KeyPair(this.public, this.secret);
}
