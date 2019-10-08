import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:aurorafiles/custom_libs/native_file_cryptor.dart';
import 'package:aurorafiles/database/app_database.dart';
import 'package:aurorafiles/models/api_body.dart';
import 'package:aurorafiles/models/storage.dart';
import 'package:aurorafiles/modules/app_store.dart';
import 'package:aurorafiles/utils/api_utils.dart';
import 'package:aurorafiles/utils/custom_exception.dart';
import 'package:aurorafiles/utils/permissions.dart';
import 'package:downloads_path_provider/downloads_path_provider.dart';
import 'package:encrypt/encrypt.dart';
import 'package:encrypt/encrypt.dart' as prefixEncrypt;
import 'package:flutter/widgets.dart';

class FilesApi {
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
      "Pattern": pattern.toLowerCase().trim(),
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

  Future<void> downloadFile(String url, LocalFile file,
      {Function(int) updateProgress,
      @required Function(String) onSuccess,
      isRedirect = false}) async {
    if (!Platform.isIOS) await getStoragePermissions();
    final String hostName = AppStore.authState.hostName;
    HttpClient client = new HttpClient();
    try {
      final HttpClientRequest request =
          await client.getUrl(Uri.parse(isRedirect ? url : hostName + url));
      request.followRedirects = false;
      if (!isRedirect) {
        request.headers
            .add("Authorization", "Bearer ${AppStore.authState.authToken}");
      }
      final HttpClientResponse response = await request.close();

      if (response.isRedirect) {
        // redirect manually with different headers
        return await downloadFile(response.headers.value("location"), file,
            onSuccess: onSuccess, updateProgress: updateProgress, isRedirect: true);
      } else {
        List<int> fileBytes = new List();
        Directory dir = await DownloadsPathProvider.downloadsDirectory;
        final fileToDownload = new File("${dir.path}/${file.name}");
        if (fileToDownload.existsSync()) {
          fileToDownload.delete();
        }
        await fileToDownload.create(recursive: true);

        if (file.initVector != null) {
          IV iv = IV.fromBase16(file.initVector);
          NativeFileCryptor.ivBase64 = iv.base64;
        }
        StreamSubscription sub;
        sub = response.listen((List<int> contents) async {
          List<int> contentsForCurrent;
          List<int> contentsForNext = contents;
          if (NativeFileCryptor.chunkMaxSize <=
              fileBytes.length + contents.length) {
            contentsForCurrent = contents.sublist(0, NativeFileCryptor.chunkMaxSize - fileBytes.length);
            contentsForNext = contents.sublist(NativeFileCryptor.chunkMaxSize - fileBytes.length, contents.length);
            fileBytes.addAll(contentsForCurrent);
            sub.pause();
            await _writeChunkToFile(
                fileBytes, file.initVector, fileToDownload, false);
            fileBytes = new List();
            sub.resume();
          }
          fileBytes.addAll(contentsForNext);
          if (updateProgress != null) updateProgress(fileBytes.length);
        }, onDone: () async {
          await _writeChunkToFile(
              fileBytes, file.initVector, fileToDownload, true);
          onSuccess(fileToDownload.path);
          sub.cancel();
        }, onError: (err) {
          print("VO: err: ${err}");
          final fileToDownload = new File("${dir.path}/${file.name}");
          fileToDownload.delete(recursive: true);
        }, cancelOnError: true);
      }
    } catch (err, stack) {
      print("VO: err: ${err}");
      print("VO: stack: ${stack}");
      throw CustomException(err.toString());
    }
  }

  Future<void> _writeChunkToFile(List<int> fileBytes, String initVector,
      File fileToDownload, bool isLast) async {
    // if encrypted - decrypt
    if (initVector != null) {
      final key =
          prefixEncrypt.Key.fromBase16(AppStore.settingsState.currentKey);
      final decrypted = await NativeFileCryptor.decrypt(
          fileBytes: fileBytes, keyBase64: key.base64, isLast: isLast);
      await fileToDownload.writeAsBytes(decrypted, mode: FileMode.append);
      // write data to file
      final newVector =
          decrypted.sublist(decrypted.length - 16, decrypted.length);
      NativeFileCryptor.ivBase64 = IV(Uint8List.fromList(newVector)).base64;
    } else {
      await fileToDownload.writeAsBytes(fileBytes, mode: FileMode.append);
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
    final int userId = AppStore.authState.userId;
    final String hostName = AppStore.authState.hostName;
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
