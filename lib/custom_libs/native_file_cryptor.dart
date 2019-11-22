import 'package:aurorafiles/utils/custom_exception.dart';
import 'package:crypto_plugin/algorithm/aes.dart';
import 'package:flutter/foundation.dart';
import 'package:moor_flutter/moor_flutter.dart';

class NativeFileCryptor {
  static int chunkMaxSize = 4000000;
  static final aes = Aes();

//
//  List<int> _getTestFileData() {
//    print("VO: !!!!!!!!!!!!!!TEST@!!!!!!!!!!");
//    final testFileData = new List<int>();
//    for (var i = 0; i <= 10000000; i++) {
//      testFileData.add(0);
//    }
//    return testFileData;
//  }
//
//  List _chunk(list) {
//    try {
//      var chunks = [];
//      for (var i = 0; i < list.length; i += chunkSize) {
//        chunks.add(list.sublist(
//            i,
//            i + chunkSize > list.length - 1
//                ? i + (list.length - i)
//                : i + chunkSize));
//      }
//      return chunks;
//    } catch (err) {
//      throw CustomException(err);
//    }
//  }

  static Future<List<int>> decrypt({
    @required List<int> fileBytes,
    @required String keyBase64,
    @required String ivBase64,
    bool isLast = false,
  }) async {
    if (fileBytes.length > chunkMaxSize) {
      throw Exception(
          "Passed chunk size for decryption (${fileBytes.length}) exceeds the max chunk size ($chunkMaxSize)");
    }
    try {
      return aes.decrypt(fileBytes, keyBase64, ivBase64);
    } catch (err, stack) {
      print("decrypt err: $err");
      print("decrypt stack: $stack");
      throw CustomExpression("Could not decrypt file");
    }
  }

  static Future<List<int>> encrypt({
    @required List<int> fileBytes,
    @required String keyBase64,
    @required String ivBase64,
    bool isLast = false,
  }) async {
    if (fileBytes.length > chunkMaxSize) {
      throw Exception(
          "Passed chunk size for decryption (${fileBytes.length}) exceeds the max chunk size ($chunkMaxSize)");
    }
    try {
      return aes.encrypt(fileBytes, keyBase64, ivBase64);
    } catch (err, stack) {
      print("encrypt err: $err");
      print("encrypt stack: $stack");
      throw CustomException("Could not encrypt file");
    }
  }
}

//class DecryptionArgs {
//  final SendPort sendPort;
//  final Uint8List fileDataBase64;
//  final String key;
//  final String iv;
//  final bool isLast;
//  final int chunkIndex;
//
//  DecryptionArgs({
//    @required this.sendPort,
//    @required this.fileDataBase64,
//    @required this.key,
//    @required this.iv,
//    @required this.isLast,
//    @required this.chunkIndex,
//  });
//}
