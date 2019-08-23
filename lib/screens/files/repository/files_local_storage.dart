import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:aurorafiles/models/api_body.dart';
import 'package:aurorafiles/store/app_state.dart';
import 'package:aurorafiles/utils/api_utils.dart';
import 'package:aurorafiles/utils/custom_exception.dart';
import 'package:downloads_path_provider/downloads_path_provider.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_uploader/flutter_uploader.dart';
import 'package:path_provider/path_provider.dart';

class FilesLocalStorage {
  final String authToken = SingletonStore.instance.authToken;
  final String hostName = SingletonStore.instance.hostName;
  final String apiUrl = SingletonStore.instance.apiUrl;
  final uploader = FlutterUploader();

  // returns paths
  Future<String> pickFiles() => FilePicker.getFilePath();

  Stream<UploadTaskResponse> uploadFile({
    @required List<FileItem> fileItems,
    @required String storageType,
    @required String path,
  }) {
    final params = json.encode({
      "Type": storageType,
      "Path": path,
      "SubPath": "",
    });

    final body =
        new ApiBody(module: "Files", method: "UploadFile", parameters: params)
            .toMap();

    uploader.enqueue(
      url: apiUrl,
      files: fileItems,
      method: UploadMethod.POST,
      headers: getHeader(authToken),
      data: body,
      showNotification: true,
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
      headers: getHeader(authToken),
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
}
