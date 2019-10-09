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

  // download file contents and write it into a file for different purposes
  // IMPORTANT! the function ends when it starts downloading
  // to get the real ending when the download is finished, pass the onSuccess callback
  Future<void> getFileContentsFromServer(
      String url, LocalFile file, File fileToWriteInto, bool decryptFile,
      {Function(int) updateProgress,
      @required Function(File) onSuccess,
      bool isRedirect = false}) async {
    // getFileContentsFromServer function assumes that fileToWriteInto exists
    final bool fileExists = await fileToWriteInto.exists();
    if (!fileExists) {
      throw CustomException("File to download data into doesn't exist");
    }

    final shouldDecrypt = decryptFile && file.initVector != null;

    final String hostName = AppStore.authState.hostName;
    HttpClient client = new HttpClient();

    try {
      final HttpClientRequest request =
          await client.getUrl(Uri.parse(isRedirect ? url : hostName + url));
      // disable auto redirects because it automatically applies the same headers, but we want different headers
      request.followRedirects = false;
      // token can only be applied to our api, in case of redirect we go to a different server, so we don't want to apply our token to such request
      if (!isRedirect) {
        request.headers
            .add("Authorization", "Bearer ${AppStore.authState.authToken}");
      }
      final HttpClientResponse response = await request.close();

      if (response.isRedirect) {
        // redirect manually with different headers
        return await getFileContentsFromServer(
            response.headers.value("location"),
            file,
            fileToWriteInto,
            shouldDecrypt,
            onSuccess: onSuccess,
            updateProgress: updateProgress,
            isRedirect: true);
      } else {
        // temporary buffer, which can hold not more than NativeFileCryptor.chunkMaxSize
        List<int> fileBytesBuffer = new List();

        // set initial vector that comes with the LocalFile object that we get from our api
        if (shouldDecrypt) {
          IV iv = IV.fromBase16(file.initVector);
          NativeFileCryptor.ivBase64 = iv.base64;
        }

        int progress = 0;

        StreamSubscription sub;
        // average size of contents ~3000 bytes
        sub = response.listen((List<int> contents) async {
          // the chunk must always be equal to NativeFileCryptor.chunkMaxSize
          // so we have to split the last part for the chunk to make it be equal to NativeFileCryptor.chunkMaxSize
          // this part goes to contentsForCurrent, the rest goes to contentsForNext, which than goes to the next chunk
          List<int> contentsForCurrent;
          // by default all the contents received go to contentsForNext which then will be added to the buffer
          // if current buffer + contentsForNext exceed NativeFileCryptor.chunkMaxSize, contentsForNext will be rewritten
          List<int> contentsForNext = contents;

          // if this is the final part that forms a chunk
          if (NativeFileCryptor.chunkMaxSize <=
              fileBytesBuffer.length + contents.length) {
            contentsForCurrent = contents.sublist(
                0, NativeFileCryptor.chunkMaxSize - fileBytesBuffer.length);

            contentsForNext = contents.sublist(
                NativeFileCryptor.chunkMaxSize - fileBytesBuffer.length,
                contents.length);

            fileBytesBuffer.addAll(contentsForCurrent);

            sub.pause();
            await _writeChunkToFile(fileBytesBuffer,
                shouldDecrypt ? file.initVector : null, fileToWriteInto, false);
            // flush the buffer
            fileBytesBuffer = new List();
            sub.resume();
          }
          fileBytesBuffer.addAll(contentsForNext);
          // the callback to update the UI download progress
          progress += contents.length;
          if (updateProgress != null) updateProgress(progress);
        }, onDone: () async {
          // when finished send all we have, if the file is decrypted, the rest will be filled with padding
          // this is why we pass true for isLast
          await _writeChunkToFile(fileBytesBuffer,
              shouldDecrypt ? file.initVector : null, fileToWriteInto, true);
          // resolve with the destination on where the downloaded file is
          onSuccess(fileToWriteInto);
          sub.cancel();
        }, onError: (err) {
          // delete the file in case of an error
          fileToWriteInto.delete(recursive: true);
          throw CustomException(err.toString());
        }, cancelOnError: true);
      }
    } catch (err, stack) {
      print("VO: err: ${err}");
      print("VO: stack: ${stack}");
      throw CustomException(err.toString());
    }
  }

  Future<void> _writeChunkToFile(List<int> fileBytes, String initVector,
      File fileToWriteInto, bool isLast) async {
    // if encrypted - decrypt
    if (initVector != null) {
      final key =
          prefixEncrypt.Key.fromBase16(AppStore.settingsState.currentKey);
      final decrypted = await NativeFileCryptor.decrypt(
          fileBytes: fileBytes, keyBase64: key.base64, isLast: isLast);
      await fileToWriteInto.writeAsBytes(decrypted, mode: FileMode.append);

      // update vector with the last 16 bytes of the chunk
      final newVector =
          decrypted.sublist(decrypted.length - 16, decrypted.length);
      NativeFileCryptor.ivBase64 = IV(Uint8List.fromList(newVector)).base64;
    } else {
      await fileToWriteInto.writeAsBytes(fileBytes, mode: FileMode.append);
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
