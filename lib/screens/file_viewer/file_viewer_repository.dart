import 'dart:convert';
import 'dart:io';

import 'package:aurorafiles/models/api_body.dart';
import 'package:aurorafiles/store/app_state.dart';
import 'package:aurorafiles/utils/api_utils.dart';
import 'package:aurorafiles/utils/custom_exception.dart';
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
      throw CustomException("Could not resolve save directory");

    return FlutterDownloader.enqueue(
      url: SingletonStore.instance.hostName + url,
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

    final body =
        new ApiBody(module: "Files", method: "Rename", parameters: parameters)
            .toMap();

    final res =
        await http.post(apiUrl, headers: getHeader(authToken), body: body);

    final resBody = json.decode(res.body);

    if (resBody['Result'] != null && resBody['Result']) {
      return newName;
    } else {
      throw CustomException(getErrMsg(resBody));
    }
  }
}
