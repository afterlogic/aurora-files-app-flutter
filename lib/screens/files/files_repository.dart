import 'dart:convert';

import 'package:aurorafiles/models/api_body.dart';
import 'package:aurorafiles/store/app_state.dart';
import 'package:aurorafiles/utils/api_utils.dart';
import 'package:aurorafiles/utils/custom_exception.dart';
import 'package:http/http.dart' as http;

class FilesRepository {
  final String hostName = SingletonStore.instance.hostName;
  final String apiUrl = SingletonStore.instance.apiUrl;
  final String authToken = SingletonStore.instance.authToken;
  final int userId = SingletonStore.instance.userId;

  Future<List> getFiles(String type, String path, String pattern) async {
    final parameters =
        json.encode({"Type": type, "Path": path, "Pattern": pattern});

    final body =
        new ApiBody(module: "Files", method: "GetFiles", parameters: parameters)
            .toMap();

    final res =
        await http.post(apiUrl, headers: getHeader(authToken), body: body);

    final resBody = json.decode(res.body);

    if (resBody['Result'] != null && resBody['Result']['Items'] is List) {
      return _sortFiles(resBody['Result']['Items']);
    } else {
      throw CustomException(getErrMsg(resBody));
    }
  }

  List _sortFiles(List unsortedFiles) {
    final List folders = List();
    final List files = List();

    unsortedFiles.forEach((item) {
      if (item["IsFolder"])
        folders.add(item);
      else
        files.add(item);
    });

    return [...folders, ...files].toList();
  }

  Future createFolder(String type, String path, String folderName) async {
    final parameters =
        json.encode({"Type": type, "Path": path, "FolderName": folderName});

    final body = new ApiBody(
            module: "Files", method: "CreateFolder", parameters: parameters)
        .toMap();

    final res =
        await http.post(apiUrl, headers: getHeader(authToken), body: body);

    final resBody = json.decode(res.body);

    if (resBody['Result']) {
      return;
    } else {
      throw CustomException(getErrMsg(resBody));
    }
  }

  Future delete(String type, String path,
      List<Map<String, dynamic>> filesToDelete) async {
    final parameters =
        json.encode({"Type": type, "Path": path, "Items": filesToDelete});

    final body =
        new ApiBody(module: "Files", method: "Delete", parameters: parameters)
            .toMap();

    final res =
        await http.post(apiUrl, headers: getHeader(authToken), body: body);

    final resBody = json.decode(res.body);

    if (resBody['Result']) {
      return;
    } else {
      throw CustomException(getErrMsg(resBody));
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
            module: "Files", method: "CreatePublicLink", parameters: parameters)
        .toMap();

    final res =
        await http.post(apiUrl, headers: getHeader(authToken), body: body);

    final resBody = json.decode(res.body);

    if (resBody['Result'] is String) {
      return "$hostName/${resBody['Result']}";
    } else {
      throw CustomException(getErrMsg(resBody));
    }
  }

  Future deletePublicLink(String type, String path, String name) async {
    final parameters = json.encode({
      "Type": type,
      "Path": path,
      "Name": name,
    });

    final body = new ApiBody(
            module: "Files", method: "DeletePublicLink", parameters: parameters)
        .toMap();

    final res =
        await http.post(apiUrl, headers: getHeader(authToken), body: body);

    final resBody = json.decode(res.body);

    if (resBody['Result']) {
      return;
    } else {
      throw CustomException(getErrMsg(resBody));
    }
  }
}
