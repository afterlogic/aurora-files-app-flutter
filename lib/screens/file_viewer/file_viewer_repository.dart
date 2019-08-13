import 'dart:io';

import 'package:aurorafiles/store/app_state.dart';
import 'package:aurorafiles/utils/custom_exception.dart';
import 'package:downloads_path_provider/downloads_path_provider.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:path_provider/path_provider.dart';

class FileViewerRepository {
  Future<String> downloadFile(String url, String fileName) async {
    Directory dir = await DownloadsPathProvider.downloadsDirectory;
    if (!dir.existsSync()) dir = await getApplicationDocumentsDirectory();
    if (!dir.existsSync())
      throw CustomException(message: "Could not resolve save directory");

    return FlutterDownloader.enqueue(
      url: SingletonStore.instance.hostName + url,
      savedDir: dir.path,
      fileName: fileName,
      headers: {'Authorization': 'Bearer ${SingletonStore.instance.authToken}'},
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
