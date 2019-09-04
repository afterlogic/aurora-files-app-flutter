import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:aurorafiles/database/app_database.dart';
import 'package:aurorafiles/models/api_body.dart';
import 'package:aurorafiles/modules/app_store.dart';
import 'package:aurorafiles/utils/api_utils.dart';
import 'package:aurorafiles/utils/custom_exception.dart';
import 'package:downloads_path_provider/downloads_path_provider.dart';
import 'package:encrypt/encrypt.dart';
import 'package:encrypt/encrypt.dart' as prefixEncrypt;
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_uploader/flutter_uploader.dart';
import 'package:path_provider/path_provider.dart';

class FilesLocalStorage {
  final String authToken = AppStore.authState.authToken;
  final String hostName = AppStore.authState.hostName;
  final String apiUrl = AppStore.authState.apiUrl;
  final uploader = FlutterUploader();

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

  Future<String> downloadFile(String url, String fileName) async {
    Directory dir = await DownloadsPathProvider.downloadsDirectory;
    if (!dir.existsSync()) dir = await getApplicationDocumentsDirectory();
    if (!dir.existsSync())
      throw CustomException("Could not resolve save directory");

    return FlutterDownloader.enqueue(
      url: hostName + url,
      savedDir: dir.path,
      fileName: fileName,
      headers: getHeader(),
      showNotification: true,
      openFileFromNotification: true,
    );
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
    Directory appDocDir = await getApplicationDocumentsDirectory();
    final encryptedFile = new File(
      '${appDocDir.path}/${file.path.split("/").last}',
    );
    final createdFile = await encryptedFile.create();

    // get key object from base16
    final key =
        prefixEncrypt.Key.fromBase16(AppStore.settingsState.encryptionKey);

    // generate vector
    Random random = Random.secure();
    var values = List<int>.generate(16, (i) => random.nextInt(256));
    final iv = IV.fromBase64(base64Encode(values));

    final encrypter = Encrypter(AES(key, mode: AESMode.cbc));

    final encrypted = encrypter.encryptBytes(fileBytes, iv: iv);
    await createdFile.writeAsBytes(encrypted.bytes);
    return [createdFile, iv.base16];
  }

  decryptFile(LocalFile file) {
    final key =
        prefixEncrypt.Key.fromBase16(AppStore.settingsState.encryptionKey);
    final iv = IV.fromBase16(file.initVector);
    final encrypter = Encrypter(AES(key, mode: AESMode.cbc));
//    final decrypted = encrypter.decryptBytes(encrypted, iv: iv);
  }
}
