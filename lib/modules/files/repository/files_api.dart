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
import 'package:aurorafiles/utils/file_utils.dart';
import 'package:encrypt/encrypt.dart';
import 'package:encrypt/encrypt.dart' as prefixEncrypt;
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;

class FilesApi {
  // to be able to cancel
  static StreamSubscription downloadSubscription;

  // to be able to delete the file in case downloading is canceled
  static File fileBeingLoaded;

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

  Future<void> uploadFile(File fileToUpload, bool shouldEncrypt,
      {String url,
      @required String storageType,
      @required String path,
      Function(int) updateProgress,
      @required Function() onSuccess}) async {
    final bool fileExists = await fileToUpload.exists();
    if (!fileExists) {
      throw CustomException("File to download data into doesn't exist");
    }

    final vectorLength = 16;
    final String apiUrl = AppStore.authState.apiUrl;

    final Map<String, dynamic> params = {
      "Type": storageType,
      "Path": path,
      "SubPath": "",
      "Overwrite": false,
    };

    if (shouldEncrypt == true) {
      final vector = IV.fromSecureRandom(vectorLength);
      NativeFileCryptor.encryptIvBase64 = vector.base64;

      params["ExtendedProps"] = {};
      params["ExtendedProps"]["InitializationVector"] = vector.base16;
      params["ExtendedProps"]["FirstChunk"] = true;
    }

    final body = new ApiBody(
            module: "Files",
            method: "UploadFile",
            parameters: jsonEncode(params))
        .toMap();
    final stream =
        new http.ByteStream(_openFileRead(fileToUpload, shouldEncrypt));
    final length = await fileToUpload.length();
    final lengthWithPadding =
        ((length / vectorLength) + 1).toInt() * vectorLength;
    print("VO: length: ${length}");
    print("VO: lengthWithPadding: ${lengthWithPadding}");

    final uri = Uri.parse(url != null ? url : apiUrl);

    final request = new http.MultipartRequest("POST", uri);
    final multipartFile = new http.MultipartFile(
        'file', stream, shouldEncrypt ? lengthWithPadding : length,
        filename: FileUtils.getFileNameFromPath(fileToUpload.path));
    //contentType: new MediaType('image', 'png'));
    if (url == null) {
      request.headers.addAll(getHeader());
    }
    request.followRedirects = false;
    request.fields.addAll(body);
    request.files.add(multipartFile);
    final response = await request.send();

    if (response.isRedirect) {
      // redirect manually with different headers
      return await uploadFile(fileToUpload, shouldEncrypt,
          url: response.headers["location"],
          path: path,
          storageType: storageType,
          onSuccess: onSuccess,
          updateProgress: updateProgress);
    } else {
      response.stream.transform(utf8.decoder).listen((result) {
        Map<String, dynamic> res = json.decode(result);

        if (res["Result"] == null || res["Result"] == false) {
          throw CustomException(getErrMsg(res));
        } else {
          onSuccess();
        }
      });
    }
  }

  Stream<List<int>> _openFileRead(File file, bool shouldEncrypt) {
    StreamController<List<int>> controller;
    StreamSubscription<List<int>> fileReadSub;
    final key = prefixEncrypt.Key.fromBase16(AppStore.settingsState.currentKey);

    final fileSize = file.lengthSync();
    int totalLength = 0;

    List<int> fileBytesBuffer = new List();
    controller = StreamController<List<int>>(onListen: () {
      fileReadSub = file.openRead().listen((contents) async {
        totalLength += contents.length;
        if (!shouldEncrypt) {
          controller.add(contents);
        } else {
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

            fileReadSub.pause();
            final encrypted = await NativeFileCryptor.encrypt(
                fileBytes: fileBytesBuffer,
                keyBase64: key.base64,
                isLast: false);
            NativeFileCryptor.encryptIvBase64 = IV(Uint8List.fromList(
                    contents.sublist(contents.length - 16, contents.length)))
                .base64;
            controller.add(encrypted);
            fileReadSub.resume();
            // flush the buffer
            fileBytesBuffer = new List();
          }
          fileBytesBuffer.addAll(contentsForNext);
          print("VO: fileBytesBuffer.length: ${fileBytesBuffer.length}");
        }
      }, onDone: () async {
        print("VO: totalLength: ${totalLength}");
        if (shouldEncrypt) {
          final encrypted = await NativeFileCryptor.encrypt(
              fileBytes: fileBytesBuffer, keyBase64: key.base64, isLast: true);
          controller.add(encrypted);
        }
        fileReadSub.cancel();
        controller.close();
      });
    },
//        onPause: fileReadSub.pause,
//        onResume: fileReadSub.resume,
        onCancel: () {
      fileReadSub.cancel();
      controller.close();
    });

    return controller.stream;
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

    fileBeingLoaded = fileToWriteInto;

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
          NativeFileCryptor.decryptIvBase64 = iv.base64;
        }

        int progress = 0;

        // average size of contents ~3000 bytes
        downloadSubscription = response.listen((List<int> contents) async {
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

            downloadSubscription.pause();
            await _writeChunkToFile(fileBytesBuffer,
                shouldDecrypt ? file.initVector : null, fileToWriteInto, false);
            // flush the buffer
            fileBytesBuffer = new List();
            downloadSubscription.resume();
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
          downloadSubscription.cancel();
          downloadSubscription = null;
          fileBeingLoaded = null;
        }, onError: (err) {
          // delete the file in case of an error
          fileToWriteInto.delete(recursive: true);
          downloadSubscription.cancel();
          downloadSubscription = null;
          fileBeingLoaded = null;
          throw CustomException(err.toString());
        }, cancelOnError: true);
      }
    } catch (err, stack) {
      print("VO: err: $err");
      print("VO: stack: $stack");
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
      NativeFileCryptor.decryptIvBase64 =
          IV(Uint8List.fromList(newVector)).base64;
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
