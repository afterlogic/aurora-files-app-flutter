import 'dart:io';
import 'dart:typed_data';

import '../crypto_plugin.dart';

class Pgp extends Crypt {
  clear() async {
    await invokeMethod(
      "$algorithm.clear",
      [],
    );
  }

  Future<Progress> getProgress() async {
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

  setTempFile(File temp) async {
    await invokeMethod(
      "$algorithm.setTempFile",
      [temp?.path],
    );
  }

  setPrivateKey(
    String key,
  ) async {
    await invokeMethod(
      "$algorithm.setPrivateKey",
      [key],
    );
  }

  setPublicKey(String key) async {
    await invokeMethod(
      "$algorithm.setPublicKey",
      [key],
    );
  }

  Future<List<int>> decryptBytes(
      List<int> encryptedBytes, String password) async {
    final result = await invokeMethod(
      "$algorithm.decryptBytes",
      [Uint8List.fromList(encryptedBytes), password],
    );
    return List<int>.from(result);
  }

  decryptFile(File inputFile, File outputFile, String password) async {
    await invokeMethod(
      "$algorithm.decryptFile",
      [inputFile.path, outputFile.path, password],
    );
  }

  Future<List<int>> encryptBytes(List<int> messageBytes) async {
    final result = await invokeMethod(
      "$algorithm.encryptBytes",
      [Uint8List.fromList(messageBytes)],
    );
    return List<int>.from(result);
  }

  encryptFile(File inputFile, File outputFile) async {
    await invokeMethod(
      "$algorithm.encryptFile",
      [inputFile.path, outputFile.path],
    );
  }

  static const algorithm = "pgp";
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
