import 'dart:convert';
import 'dart:io';

import 'package:aurorafiles/store/app_state.dart';
import 'package:aurorafiles/utils/custom_exception.dart';
import 'package:aurorafiles/utils/get_error_message.dart';
import 'package:downloads_path_provider/downloads_path_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

class FileViewerRepository {
  final String apiUrl = SingletonStore.instance.apiUrl;
  final String authToken = SingletonStore.instance.authToken;

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

  Future<String> renameFile({
    @required String type,
    @required String path,
    @required String name,
    @required String newName,
    @required bool isLink,
    @required bool isFolder,
  }) async {
    final parameters = json.encode({
      "Type": type,
      "Path": path,
      "Name": name,
      "NewName": newName,
      "IsLink": isLink,
      "IsFolder": isFolder,
    });

    final res = await http.post(apiUrl, headers: {
      'Authorization': 'Bearer $authToken'
    }, body: {
      'Module': 'Files',
      'Method': 'Rename',
      'Parameters': parameters
    });

    final resBody = json.decode(res.body);

    if (resBody['Result'] != null && resBody['Result']) {
      return newName;
    } else {
      throw CustomException(
          message: resBody["ErrorMessage"] != null
              ? resBody["ErrorMessage"]
              : getErrMsgFromCode(resBody["ErrorCode"]));
    }
  }
}
