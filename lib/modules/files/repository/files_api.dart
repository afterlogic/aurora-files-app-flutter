import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:aurorafiles/database/app_database.dart';
import 'package:aurorafiles/di/di.dart';
import 'package:aurorafiles/models/api_body.dart';
import 'package:aurorafiles/models/processing_file.dart';
import 'package:aurorafiles/models/quota.dart';
import 'package:aurorafiles/models/secure_link.dart';
import 'package:aurorafiles/models/storage.dart';
import 'package:aurorafiles/modules/app_store.dart';
import 'package:aurorafiles/modules/settings/repository/pgp_key_util.dart';
import 'package:aurorafiles/utils/api_utils.dart';
import 'package:aurorafiles/utils/custom_exception.dart';
import 'package:aurorafiles/utils/file_utils.dart';
import 'package:aurorafiles/utils/stream_util.dart';
import 'package:crypto_stream/algorithm/aes.dart';
import 'package:encrypt/encrypt.dart';
import 'package:encrypt/encrypt.dart' as prefixEncrypt;
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;

class FilesApi {
  Aes aes = DI.get();

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

  Future<GetFilesResponse> getFiles(
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
      final quota = Quota.getQuotaFromResponse(res['Result']['Quota']);
      res['Result']['Items']
          .forEach((file) => unsortedList.add(getFileObjFromResponse(file)));

      return new GetFilesResponse(
          _sortFiles(unsortedList), quota?.limit == 0 ? null : quota);
    } else {
      throw CustomException(getErrMsg(res));
    }
  }

  Future<void> uploadFile(
    ProcessingFile processingFile,
    bool shouldEncrypt, {
    String url,
    String name,
    bool passwordEncryption,
    String encryptionRecipientEmail,
    List<LocalPgpKey> addedPgpKey,
    @required String storageType,
    @required String path,
    Function(int) updateProgress,
    @required Function() onSuccess,
    @required Function(String) onError,
  }) async {
    final bool fileExists = await processingFile.fileOnDevice.exists();
    if (!fileExists) {
      throw CustomException("File to download data into doesn't exist");
    }

    final vectorLength = 16;
    final String url = AppStore.authState.apiUrl;

    final Map<String, dynamic> params = {
      "Type": storageType,
      "Path": path,
      "SubPath": "",
      "Overwrite": false,
    };
    params["ExtendedProps"] = {};

    if (passwordEncryption == true) {
      params["ExtendedProps"]["PgpEncryptionMode"] = "password";
      params["ExtendedProps"]["PgpEncryptionRecipientEmail"] =
          encryptionRecipientEmail;
    }

    String encryptKey = prefixEncrypt.Key.fromSecureRandom(32).base16;
    if (shouldEncrypt == true) {
      final vector = IV.fromSecureRandom(vectorLength);
      processingFile.ivBase64 = vector.base64;
      params["ExtendedProps"]["ParanoidKey"] =
          (await PgpKeyUtil.instance.userEncrypt(encryptKey))
              .replaceAll("\n", "\r\n");
      params["ExtendedProps"]["InitializationVector"] = vector.base16;
      params["ExtendedProps"]["FirstChunk"] = true;
    }

    final body = new ApiBody(
            module: "Files",
            method: "UploadFile",
            parameters: jsonEncode(params))
        .toMap();
    final stream = new http.ByteStream(
        _openFileRead(processingFile, shouldEncrypt, onError, encryptKey));
    final length = await processingFile.fileOnDevice.length();
    final lengthWithPadding =
        ((length / vectorLength) + 1).toInt() * vectorLength;

    final uri = Uri.parse(url);

    final requestMultipart = new http.MultipartRequest("POST", uri);
    final multipartFile = new http.MultipartFile(
        'file', stream, shouldEncrypt ? lengthWithPadding : length,
        filename: name ??
            FileUtils.getFileNameFromPath(processingFile.fileOnDevice.path));

    requestMultipart.headers.addAll(getHeader());

    requestMultipart.fields.addAll(body);
    requestMultipart.files.add(multipartFile);

    final response = await requestMultipart.send();
    final result = await response.stream.bytesToString();
    Map<String, dynamic> res = json.decode(result);

    if (res["Result"] == null || res["Result"] == false) {
      onError(getErrMsg(res));
    } else {
      processingFile.endProcess();
      onSuccess();
    }
  }

  Stream<List<int>> _openFileRead(ProcessingFile processingFile,
      bool shouldEncrypt, Function(String) onError, String encryptKey) {
    StreamController<List<int>> controller;
    StreamSubscription<List<int>> fileReadSub;
    final key = shouldEncrypt ? prefixEncrypt.Key.fromBase16(encryptKey) : null;

    int bytesUploaded = 0;

    List<int> fileBytesBuffer = new List();
    controller = StreamController<List<int>>(onListen: () {
      fileReadSub =
          processingFile.fileOnDevice.openRead().listen((contents) async {
        bytesUploaded += contents.length;
        final num = 100 / processingFile.size * bytesUploaded / 100;

        processingFile.updateProgress(num);
        if (!shouldEncrypt) {
          controller.add(contents);
        } else {
          // the chunk must always be equal to aes.chunkMaxSize
          // so we have to split the last part for the chunk to make it be equal to aes.chunkMaxSize
          // this part goes to contentsForCurrent, the rest goes to contentsForNext, which than goes to the next chunk
          List<int> contentsForCurrent;
          // by default all the contents received go to contentsForNext which then will be added to the buffer
          // if current buffer + contentsForNext exceed aes.chunkMaxSize, contentsForNext will be rewritten
          List<int> contentsForNext = contents;

          // if this is the final part that forms a chunk
          if (Aes.chunkMaxSize <= fileBytesBuffer.length + contents.length) {
            contentsForCurrent =
                contents.sublist(0, Aes.chunkMaxSize - fileBytesBuffer.length);

            contentsForNext = contents.sublist(
                Aes.chunkMaxSize - fileBytesBuffer.length, contents.length);

            fileBytesBuffer.addAll(contentsForCurrent);

            fileReadSub.pause();
            final encrypted = await aes.encrypt(
                fileBytesBuffer, key.base64, processingFile.ivBase64, false);
            processingFile.ivBase64 = IV(Uint8List.fromList(
                    encrypted.sublist(encrypted.length - 16, encrypted.length)))
                .base64;
            controller.add(encrypted);
            fileReadSub.resume();
            // flush the buffer
            fileBytesBuffer = new List();
          }
          fileBytesBuffer.addAll(contentsForNext);
        }
      }, onDone: () async {
        if (shouldEncrypt) {
          final encrypted = await aes.encrypt(
              fileBytesBuffer, key.base64, processingFile.ivBase64, true);
          controller.add(encrypted);
        }
        fileReadSub.cancel();
        controller.close();
      }, onError: (err, stack) {
        print("_openFileRead err: $err");
        print("_openFileRead stack: $stack");
        onError("Error occured, could not upload file.");
      }, cancelOnError: true);
    },
//        onPause: fileReadSub.pause,
//        onResume: fileReadSub.resume,
        onCancel: () {
      fileReadSub.cancel();
      controller.close();
    });
    processingFile.subscription = fileReadSub;

    return controller.stream;
  }

  // download file contents and write it into a file for different purposes
  // IMPORTANT! the function ends when it starts downloading
  // to get the real ending when the download is finished, pass the onSuccess callback
  Future<StreamSubscription> getFileContentsFromServer(
    String url,
    LocalFile file,
    ProcessingFile processingFile,
    bool decryptFile,
    String keyPassword, {
    Function(String) onError,
    Function(double) updateViewerProgress,
    @required Function(File) onSuccess,
    bool isRedirect = false,
  }) async {
    // getFileContentsFromServer function assumes that fileToWriteInto exists
    final bool fileExists = await processingFile.fileOnDevice.exists();
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
            processingFile,
            shouldDecrypt,
            keyPassword,
            updateViewerProgress: updateViewerProgress,
            onSuccess: onSuccess,
            onError: onError,
            isRedirect: true);
      }
      // temporary buffer, which can hold not more than aes.chunkMaxSize
      List<int> fileBytesBuffer = new List();

      // set initial vector that comes with the LocalFile object that we get from our api
      String decryptKey;
      if (shouldDecrypt) {
        decryptKey = keyPassword;
        IV iv = IV.fromBase16(file.initVector);
        processingFile.ivBase64 = iv.base64;
        decryptKey = await PgpKeyUtil.instance.userDecrypt(
            file.type == "shared"
                ? jsonDecode(file.extendedProps)["ParanoidKeyShared"]
                : file.encryptedDecryptionKey,
            decryptKey);
      }

      int progress = 0;

      StreamSubscription downloadSubscription;
      // average size of contents ~3000 bytes
      downloadSubscription = listener<List<int>>(
        response,
        (List<int> contents) async {
          // the chunk must always be equal to aes.chunkMaxSize
          // so we have to split the last part for the chunk to make it be equal to aes.chunkMaxSize
          // this part goes to contentsForCurrent, the rest goes to contentsForNext, which than goes to the next chunk
          List<int> contentsForCurrent;
          // by default all the contents received go to contentsForNext which then will be added to the buffer
          // if current buffer + contentsForNext exceed aes.chunkMaxSize, contentsForNext will be rewritten
          List<int> contentsForNext = contents;

          // if this is the final part that forms a chunk
          if (Aes.chunkMaxSize <= fileBytesBuffer.length + contents.length) {
            contentsForCurrent =
                contents.sublist(0, Aes.chunkMaxSize - fileBytesBuffer.length);

            contentsForNext = contents.sublist(
                Aes.chunkMaxSize - fileBytesBuffer.length, contents.length);

            fileBytesBuffer.addAll(contentsForCurrent);

            downloadSubscription.pause();
            await _writeChunkToFile(
              fileBytesBuffer,
              shouldDecrypt ? file.initVector : null,
              processingFile,
              false,
              decryptKey,
            );
            // flush the buffer
            fileBytesBuffer = new List();
            downloadSubscription.resume();
          }
          fileBytesBuffer.addAll(contentsForNext);
          // the callback to update the UI download progress
          // update progress
          progress += contents.length;
          final num = 100 / file.size * progress / 100;
          processingFile.updateProgress(num);
          if (updateViewerProgress != null) updateViewerProgress(num);
        },
        onDone: () async {
          // when finished send all we have, if the file is decrypted, the rest will be filled with padding
          // this is why we pass true for isLast
          await _writeChunkToFile(
            fileBytesBuffer,
            shouldDecrypt ? file.initVector : null,
            processingFile,
            true,
            decryptKey,
          );
          // resolve with the destination on where the downloaded file is
          onSuccess(processingFile.fileOnDevice);
        },
        onError: (err) {
          // delete the file in case of an error
          processingFile.fileOnDevice.delete(recursive: true);
          onError(err.toString());
        },
        cancelOnError: true,
      );
      return downloadSubscription;
    } catch (err) {
      throw CustomException(err.toString());
    }
  }

  Future<void> _writeChunkToFile(List<int> fileBytes, String initVector,
      ProcessingFile processingFile, bool isLast, String decryptKey) async {
    // if encrypted - decrypt
    if (initVector != null) {
      final key = prefixEncrypt.Key.fromBase16(decryptKey.replaceAll("�", ""));
      final decrypted = await aes.decrypt(
          fileBytes, key.base64, processingFile.ivBase64, isLast);
      await processingFile.fileOnDevice
          .writeAsBytes(decrypted, mode: FileMode.append);

      // update vector with the last 16 bytes of the chunk
      final newVector =
          fileBytes.sublist(fileBytes.length - 16, fileBytes.length);
      processingFile.ivBase64 = IV(Uint8List.fromList(newVector)).base64;
    } else {
      await processingFile.fileOnDevice
          .writeAsBytes(fileBytes, mode: FileMode.append);
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

  Future<SecureLink> createSecureLink(
    String type,
    String path,
    String name,
    int size,
    bool isFolder,
    String linkPassword,
    bool isKey,
    String email,
  ) async {
    final String hostName = AppStore.authState.hostName;
    final parameters = {
      "Type": type,
      "Path": path,
      "Name": name,
      "Size": size,
      "IsFolder": isFolder,
      "Password": linkPassword,
      "RecipientEmail": email,
      "PgpEncryptionMode": isKey ? "key" : "password",
    };

    final body = new ApiBody(
        module: "OpenPgpFilesWebclient",
        method: "CreatePublicLink",
        parameters: json.encode(parameters));

    final res = await sendRequest(body, {"TenantName": "Default"}) as Map;

    if (res.containsKey("Result")) {
      return SecureLink(
          hostName + "/" + res["Result"]["link"], res["Result"]["password"]);
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

  Future updateExtendedProps(
      LocalFile file, String encryptionKey, List<String> contactKey) async {
    final parameters = json.encode({
      "Type": file.type,
      "Path": file.path,
      "Name": file.name,
      "ExtendedProps": {
        "ParanoidKeyShared":
            (await PgpKeyUtil.instance.encrypt(encryptionKey, contactKey))
                .replaceAll("\n", "\r\n")
      }
    });

    final body = new ApiBody(
      module: "Files",
      method: "UpdateExtendedProps",
      parameters: parameters,
    );

    final res = await sendRequest(body);
    if (res['Result'] == true) {
      return;
    } else {
      throw CustomException(getErrMsg(res));
    }
  }

  Future updateExtendedPropsPublicKey(
      LocalFile file, String paranoidKeyPublic) async {
    final parameters = json.encode({
      "Type": file.type,
      "Path": file.path,
      "Name": file.name,
      "ExtendedProps": {
        "ParanoidKeyPublic": paranoidKeyPublic,
      }
    });

    final body = new ApiBody(
      module: "Files",
      method: "UpdateExtendedProps",
      parameters: parameters,
    );

    final res = await sendRequest(body);
    if (res['Result'] == true) {
      return;
    } else {
      throw CustomException(getErrMsg(res));
    }
  }
}

class GetFilesResponse {
  final List<LocalFile> items;
  final Quota quota;

  GetFilesResponse(this.items, this.quota);
}
