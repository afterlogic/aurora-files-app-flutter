import 'dart:convert';
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
    if (Platform.isIOS) return null;

    final result = await invokeMethod(
      "$algorithm.getProgress",
      [],
    );
    if (result is List) {
      final list = List<int>.from(result);
      return Progress(list[0].toDouble(), list[1].toDouble());
    } else {
      return null;
    }
  }

  Future setTempFile(File temp) async {
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
      Uint8List encryptedBytes, String password, bool checkSign) async {
    final result = await invokeMethod(
      "$algorithm.decryptBytes",
      [encryptedBytes, password, checkSign],
    );
    return List<int>.from(result);
  }

  Future decryptFile(
      File inputFile, File outputFile, String password, bool checkSign) async {
    await invokeMethod(
      "$algorithm.decryptFile",
      [inputFile.path, outputFile.path, password, checkSign],
    );
  }

  Future<List<int>> encryptBytes(Uint8List messageBytes, String passwordForSign) async {
    final result = await invokeMethod(
      "$algorithm.encryptBytes",
      [messageBytes, passwordForSign],
    );
    return List<int>.from(result);
  }

  Future<void> encryptFile(File inputFile, File outputFile, String passwordForSign) async {
    await invokeMethod(
      "$algorithm.encryptFile",
      [inputFile.path, outputFile.path, passwordForSign],
    );
  }

  Future<List<int>> decryptSymmetricBytes(
      Uint8List encryptedBytes, String password) async {
    final result = await invokeMethod(
      "$algorithm.decryptSymmetricBytes",
      [encryptedBytes, password],
    );
    return List<int>.from(result);
  }

  Future decryptSymmetricFile(
      File inputFile, File outputFile, String password) async {
    await invokeMethod(
      "$algorithm.decryptSymmetricFile",
      [inputFile.path, outputFile.path, password],
    );
  }

  Future<List<int>> encryptSymmetricBytes(
      Uint8List messageBytes, String password) async {
    final result = await invokeMethod(
      "$algorithm.encryptSymmetricBytes",
      [messageBytes, password],
    );
    return List<int>.from(result);
  }

  Future<void> encryptSymmetricFile(
      File inputFile, File outputFile, String password) async {
    await invokeMethod(
      "$algorithm.encryptSymmetricFile",
      [inputFile.path, outputFile.path, password],
    );
  }

  static const algorithm = "pgp";

  Future<KeyDescription> getKeyDescription(String key) async {
    final result = await invokeMethod(
      "$algorithm.getKeyDescription",
      [key],
    );
    if (result is List) {
      return KeyDescription(List<String>.from(result[0]), result[1], result[2]);
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

  Future<bool> checkPassword(String password, String key) async {
    final result = await invokeMethod(
      "$algorithm.checkPassword",
      [password, key],
    );
    if (result is bool) {
      return result;
    } else {
      return null;
    }
  }
}

class Progress {
  final double total;
  final double current;

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
  final bool isPrivate;

  KeyDescription(this.email, this.length, this.isPrivate);
}

class KeyPair {
  final String public;
  final String secret;

  KeyPair(this.public, this.secret);
}
