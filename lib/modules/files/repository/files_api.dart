import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:aurorafiles/database/app_database.dart';
import 'package:aurorafiles/models/api_body.dart';
import 'package:aurorafiles/models/storage.dart';
import 'package:aurorafiles/modules/app_store.dart';
import 'package:aurorafiles/utils/api_utils.dart';
import 'package:aurorafiles/utils/custom_exception.dart';
import 'package:flutter/widgets.dart';

class FilesApi {
  final String hostName = AppStore.authState.hostName;
  final String apiUrl = AppStore.authState.apiUrl;
  final String authToken = AppStore.authState.authToken;
  final int userId = AppStore.authState.userId;

  List<LocalFile> _sortFiles(List<LocalFile> unsortedFiles) {
    final List<LocalFile> folders = List();
    final List<LocalFile> files = List();

    unsortedFiles.forEach((item) {
      if (item.isFolder)
        folders.add(item);
      else
        files.add(item);
    });

    return [...folders, ...files].toList();
  }

  Future<List<Storage>> getStorages() async {
    final body = new ApiBody(module: "Files", method: "GetStorages");
    final res = await sendRequest(body);

    if (res['Result'] is List) {
      final List<Storage> storages = [];
      res['Result']
          .forEach((rawStorage) => storages.add(Storage.fromMap(rawStorage)));
      return storages;
    } else {
      throw CustomException(getErrMsg(res));
    }
  }

  Future<List<LocalFile>> getFiles(
      String type, String path, String pattern) async {
    final parameters = json.encode({
      "Type": type,
      "Path": path,
      "Pattern": pattern,
      "PathRequired": false,
    });

    final body = new ApiBody(
        module: "Files", method: "GetFiles", parameters: parameters);

    final res = await sendRequest(body);

    if (res['Result'] != null && res['Result']['Items'] is List) {
      final List<LocalFile> unsortedList = [];
      res['Result']['Items']
          .forEach((file) => unsortedList.add(getFileObjFromResponse(file)));
      return _sortFiles(unsortedList);
    } else {
      throw CustomException(getErrMsg(res));
    }
  }

  Future<List<int>> downloadFileForPreview(url,
      {Function(int) updateProgress}) async {
    HttpClient client = new HttpClient();
    final HttpClientRequest request =
        await client.getUrl(Uri.parse(hostName + url));

    request.headers
        .add("Authorization", "Bearer ${AppStore.authState.authToken}");
    final HttpClientResponse response = await request.close();

    List<int> fileBytes = new List();

    await for (List<int> contents in response) {
      fileBytes = [...fileBytes, ...contents];
      updateProgress(Uint8List.fromList(fileBytes).lengthInBytes);
    }

    return fileBytes;
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
        new ApiBody(module: "Files", method: "Rename", parameters: parameters);

    final res = await sendRequest(body);

    if (res['Result'] != null && res['Result']) {
      return newName;
    } else {
      throw CustomException(getErrMsg(res));
    }
  }

  Future createFolder(String type, String path, String folderName) async {
    final parameters =
        json.encode({"Type": type, "Path": path, "FolderName": folderName});

    final body = new ApiBody(
        module: "Files", method: "CreateFolder", parameters: parameters);

    final res = await sendRequest(body);

    if (res['Result']) {
      return;
    } else {
      throw CustomException(getErrMsg(res));
    }
  }

  Future delete(String type, String path,
      List<Map<String, dynamic>> filesToDelete) async {
    final parameters =
        json.encode({"Type": type, "Path": path, "Items": filesToDelete});

    final body =
        new ApiBody(module: "Files", method: "Delete", parameters: parameters);

    final res = await sendRequest(body);

    if (res['Result']) {
      return;
    } else {
      throw CustomException(getErrMsg(res));
    }
  }

  Future<String> createPublicLink(
      String type, String path, String name, int size, bool isFolder) async {
    final parameters = json.encode({
      "UserId": userId,
      "Type": type,
      "Path": path,
      "Name": name,
      "Size": size,
      "IsFolder": isFolder,
    });

    final body = new ApiBody(
        module: "Files", method: "CreatePublicLink", parameters: parameters);

    final res = await sendRequest(body);

    if (res['Result'] is String) {
      return "$hostName/${res['Result']}";
    } else {
      throw CustomException(getErrMsg(res));
    }
  }

  Future deletePublicLink(String type, String path, String name) async {
    final parameters = json.encode({
      "Type": type,
      "Path": path,
      "Name": name,
    });

    final body = new ApiBody(
        module: "Files", method: "DeletePublicLink", parameters: parameters);

    final res = await sendRequest(body);

    if (res['Result']) {
      return;
    } else {
      throw CustomException(getErrMsg(res));
    }
  }

  Future copyMoveFiles({
    @required bool copy,
    @required String fromType,
    @required String toType,
    @required String fromPath,
    @required String toPath,
    @required List<Map<String, dynamic>> files,
  }) async {
    final parameters = json.encode({
      "FromType": fromType,
      "ToType": toType,
      "FromPath": fromPath,
      "ToPath": toPath,
      "Files": files
    });

    final body = new ApiBody(
      module: "Files",
      method: copy ? "Copy" : "Move",
      parameters: parameters,
    );

    final res = await sendRequest(body);
    if (res['Result']) {
      return;
    } else {
      throw CustomException(getErrMsg(res));
    }
  }
}
