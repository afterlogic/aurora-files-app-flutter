import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:aurorafiles/database/app_database.dart';
import 'package:aurorafiles/models/api_body.dart';
import 'package:aurorafiles/modules/app_store.dart';
import 'package:aurorafiles/utils/api_utils.dart';
import 'package:aurorafiles/utils/custom_exception.dart';
import 'package:aurorafiles/utils/file_utils.dart';
import 'package:downloads_path_provider/downloads_path_provider.dart';
import 'package:encrypt/encrypt.dart';
import 'package:encrypt/encrypt.dart' as prefixEncrypt;
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_uploader/flutter_uploader.dart';
import 'package:intl/intl.dart';
import 'package:moor_flutter/moor_flutter.dart';
import 'package:path_provider/path_provider.dart';

class FilesLocalStorage {
  final String authToken = AppStore.authState.authToken;
  final String hostName = AppStore.authState.hostName;
  final String apiUrl = AppStore.authState.apiUrl;
  final uploader = FlutterUploader();
  final chunkSize = 128000;

  Future<File> pickFiles({FileType type, String extension}) {
    return FilePicker.getFile(type: type, fileExtension: extension);
  }

  Stream<UploadTaskResponse> uploadFile({
    @required FileItem fileItem,
    @required String storageType,
    @required String path,
    String vector,
    bool firstChunk = true,
  }) {
    final Map<String, dynamic> params = {
      "Type": storageType,
      "Path": path,
      "SubPath": "",
      "Overwrite": false,
    };

    if (vector is String) {
      params["ExtendedProps"] = {};
      params["ExtendedProps"]["InitializationVector"] = vector;
      params["ExtendedProps"]["FirstChunk"] = firstChunk;
    }

    final body = new ApiBody(
            module: "Files",
            method: "UploadFile",
            parameters: jsonEncode(params))
        .toMap();

    uploader.enqueue(
      url: apiUrl,
      files: [fileItem],
      method: UploadMethod.POST,
      headers: getHeader(),
      data: body,
      showNotification: true,
      tag: fileItem.filename,
    );

    return uploader.result;
  }

  // returns taskId e.g. b95fa992-3113-4ecc-bbec-80117206e3e3
  Future<String> downloadFile(String url, String fileName) async {
    Directory dir = await DownloadsPathProvider.downloadsDirectory;
    if (!dir.existsSync()) dir = await getApplicationDocumentsDirectory();
    if (!dir.existsSync())
      throw CustomException("Could not resolve save directory");

    await FlutterDownloader.enqueue(
      url: hostName + url,
      savedDir: dir.path,
      fileName: fileName,
      headers: getHeader(),
      showNotification: true,
      openFileFromNotification: true,
    );
    return dir.path;
  }

  void getDownloadStatus(Function onSuccess) {
    FlutterDownloader.registerCallback((id, status, progress) {
      if (status == DownloadTaskStatus.complete) {
        onSuccess();
        FlutterDownloader.registerCallback(null);
      }
    });
  }

  Future<List> encryptFile(File file) async {
    final fileBytes = await file.readAsBytes();
    final chunkedList = _chunk(fileBytes);
    Directory appDocDir = await getApplicationDocumentsDirectory();
    final encryptedFile = new File(
      '${appDocDir.path}/temp_encrypted_files/${FileUtils.getFileNameFromPath(file.path)}',
    );
    final createdFile = await encryptedFile.create(recursive: true);

    final key = prefixEncrypt.Key.fromBase16(AppStore.settingsState.currentKey);
    final iv = IV.fromSecureRandom(16);
    IV nextVector = iv;
    for (final List<int> chunk in chunkedList) {
      final padding =
          chunkedList.indexOf(chunk) == chunkedList.length - 1 ? "PKCS7" : null;
      final encrypter =
          Encrypter(AES(key, mode: AESMode.cbc, padding: padding));
      final args = {
        "encrypter": encrypter,
        "fileBytes": chunk,
        "iv": nextVector
      };
      final result = await compute(_encrypt, args);
      await createdFile.writeAsBytes(result.bytes, mode: FileMode.append);

      nextVector = IV(Uint8List.fromList(
          result.bytes.sublist(result.bytes.length - 16, result.bytes.length)));
    }

    return [createdFile, iv.base16];
  }

  Future<List<int>> decryptFile({
    @required LocalFile file,
    @required List<int> fileBytes,
    Function(int) updateProgress,
  }) async {
    final key = prefixEncrypt.Key.fromBase16(AppStore.settingsState.currentKey);
    IV iv = IV.fromBase16(file.initVector);
    List<int> encryptedFileBytes = fileBytes;
    List<int> decryptedFileBytes = new List();

    final chunkedList = _chunk(encryptedFileBytes);
    print(
        "${DateFormat('H:m:s:ms').format(DateTime.now())} VO: decrypting file...");
    for (final List<int> chunk in chunkedList) {
      final padding =
          chunkedList.indexOf(chunk) == chunkedList.length - 1 ? "PKCS7" : null;
      final encrypter =
          Encrypter(AES(key, mode: AESMode.cbc, padding: padding));
      final encrypted = Encrypted(Uint8List.fromList(chunk));
      final args = {"encrypter": encrypter, "encrypted": encrypted, "iv": iv};
      final result = await compute(_decrypt, args);
      final newVector = chunk.sublist(chunk.length - 16, chunk.length);

      iv = IV(Uint8List.fromList(newVector));
      decryptedFileBytes = [...decryptedFileBytes, ...result];
    }
    print("${DateFormat('H:m:s:ms').format(DateTime.now())} VO: finish");
    return decryptedFileBytes;
  }

  _chunk(list) => list.toList().isEmpty
      ? list.toList()
      : ([list.take(chunkSize).toList()]
        ..addAll(_chunk(list.skip(chunkSize).toList())));

  static Encrypted _encrypt(Map args) {
    return args["encrypter"].encryptBytes(args["fileBytes"], iv: args["iv"]);
  }

  static List<int> _decrypt(Map args) {
    return args["encrypter"].decryptBytes(args["encrypted"], iv: args["iv"]);
  }
}
