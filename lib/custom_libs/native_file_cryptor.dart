import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:moor_flutter/moor_flutter.dart';

class NativeFileCryptor {
  static const _platformEncryptionChannel =
      const MethodChannel("PrivateMailFiles.PrivateRouter.com/encryption");

  static int chunkMaxSize = 4000000;

  static String ivBase64;

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
    bool isLast = false,
    Function(double) updateProgress,
  }) async {
    if (fileBytes.length > chunkMaxSize) {
      throw Exception(
          "Passed chunk size for decryption (${fileBytes.length}) exceeds the max chunk size ($chunkMaxSize)");
    }
    try {
      final List<dynamic> decrypted = await _platformEncryptionChannel
          .invokeMethod(
              "decrypt", [Uint8List.fromList(fileBytes), keyBase64, ivBase64, isLast]);

      return new List<int>.from(decrypted);
    } catch (err, stack) {
      print("VO: err: ${err}");
      print("VO: stack: ${stack}");
      throw CustomExpression("Could not decrypt file");
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
