import 'dart:convert';

import 'package:aurorafiles/database/app_database.dart';
import 'package:aurorafiles/models/api_body.dart';
import 'package:aurorafiles/models/storage.dart';
import 'package:aurorafiles/store/app_state.dart';
import 'package:aurorafiles/utils/api_utils.dart';
import 'package:aurorafiles/utils/custom_exception.dart';
import 'package:flutter/widgets.dart';

class FilesApi {
  final String hostName = SingletonStore.instance.hostName;
  final String apiUrl = SingletonStore.instance.apiUrl;
  final String authToken = SingletonStore.instance.authToken;
  final int userId = SingletonStore.instance.userId;

  List<File> _sortFiles(List<File> unsortedFiles) {
    final List<File> folders = List();
    final List<File> files = List();

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
      res['Result'].forEach((rawStorage) =>
          storages.add(Storage.fromMap(rawStorage)));
      return storages;
    } else {
      throw CustomException(getErrMsg(res));
    }
  }

  Future<List<File>> getFiles(String type, String path, String pattern) async {
    final parameters =
        json.encode({"Type": type, "Path": path, "Pattern": pattern});

    final body = new ApiBody(
        module: "Files", method: "GetFiles", parameters: parameters);

    final res = await sendRequest(body);

    if (res['Result'] != null && res['Result']['Items'] is List) {
      final List<File> unsortedList = [];
      res['Result']['Items']
          .forEach((file) => unsortedList.add(getFileObjFromResponse(file)));
      return _sortFiles(unsortedList);
    } else {
      throw CustomException(getErrMsg(res));
    }
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
