import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:aurorafiles/database/app_database.dart';
import 'package:aurorafiles/models/api_body.dart';
import 'package:aurorafiles/modules/app_store.dart';
import 'package:aurorafiles/utils/api_utils.dart';
import 'package:aurorafiles/utils/custom_exception.dart';
import 'package:aurorafiles/utils/file_utils.dart';
import 'package:aurorafiles/utils/permissions.dart';
import 'package:downloads_path_provider/downloads_path_provider.dart';
import 'package:encrypt/encrypt.dart';
import 'package:encrypt/encrypt.dart' as prefixEncrypt;
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_uploader/flutter_uploader.dart';
import 'package:moor_flutter/moor_flutter.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_extend/share_extend.dart';

class FilesLocalStorage {
  final uploader = FlutterUploader();

  Future<File> pickFiles({FileType type, String extension}) {
    return FilePicker.getFile(type: type, fileExtension: extension);
  }

  Stream<UploadTaskResponse> uploadFile({
    @required FileItem fileItem,
    @required String storageType,
    @required String path,
    String vector,
    bool firstChunk = true,
  }) {
    final String apiUrl = AppStore.authState.apiUrl;
    final Map<String, dynamic> params = {
      "Type": storageType,
      "Path": path,
      "SubPath": "",
      "Overwrite": false,
    };

    if (vector is String) {
      params["ExtendedProps"] = {};
      params["ExtendedProps"]["InitializationVector"] = vector;
      params["ExtendedProps"]["FirstChunk"] = firstChunk;
    }

    final body = new ApiBody(
            module: "Files",
            method: "UploadFile",
            parameters: jsonEncode(params))
        .toMap();
    uploader.enqueue(
      url: apiUrl,
      files: [fileItem],
      method: UploadMethod.POST,
      headers: getHeader(),
      data: body,
      showNotification: true,
      tag: fileItem.filename,
    );

    return uploader.result;
  }

  // is used to download files on iOS
  Future<void> shareFile(File storedFile, LocalFile file) async {
    String fileType;
    if (file.contentType.startsWith("image"))
      fileType = "image";
    else if (file.contentType.startsWith("video"))
      fileType = "video";
    else
      fileType = "file";

    await ShareExtend.share(storedFile.path, fileType);
  }

  Future<void> openFileWith(File file) async {
//    final tempFileForShare = await cacheFile(fileBytes, file);
    return OpenFile.open(file.path);
  }

//  Future<String> saveFileInDownloads(
//      List<int> fileBytes, LocalFile file) async {
//    if (!Platform.isIOS) await getStoragePermissions();
//    Directory dir = await DownloadsPathProvider.downloadsDirectory;
//
//    final fileToDownload = new File("${dir.path}/${file.name}");
//    await fileToDownload.create(recursive: true);
//    await fileToDownload.writeAsBytes(fileBytes);
//
//    return fileToDownload.path;
//  }

  // works on android only, to download files on iOS use Share
  Future<File> createFileForDownloadAndroid(LocalFile file) async {
    if (!Platform.isIOS) await getStoragePermissions();

    final Directory dir = await DownloadsPathProvider.downloadsDirectory;
    File dartFile = new File("${dir.path}/${file.name}");

    // if name exists add suffix (name_0.png)
    int suffix = 0;
    while (await dartFile.exists()) {
      final List splitName = file.name.split(".");
      final String ext = splitName.last;
      splitName.removeLast();
      final String nameWithoutExt = splitName.join(".");
      dartFile = new File("${dir.path}/${nameWithoutExt}_$suffix.$ext");
      suffix++;
    }
    await dartFile.create(recursive: true);
    return dartFile;
  }

  // such files are deleted periodically (e.g. share, non-image cache)
  Future<File> createTempFile(LocalFile file, {bool useName = false}) async {
    if (!Platform.isIOS) await getStoragePermissions();

    final Directory dir = await getTemporaryDirectory();
    final File dartFile = new File(
        "${dir.path}/files_to_delete/${useName == true ? file.name : file.guid}");
    if (await dartFile.exists()) {
      return dartFile;
    } else {
      await dartFile.create(recursive: true);
      return dartFile;
    }
  }

  Future<File> createImageCacheFile(LocalFile file) async {
    if (file.initVector != null) {
      throw CustomException("Cannot cache encrypted image contents");
    }
    if (!Platform.isIOS) await getStoragePermissions();

    final Directory dir = await getTemporaryDirectory();
    final File dartFile = new File("${dir.path}/images/${file.guid}");
    if (await dartFile.exists()) {
      return dartFile;
    } else {
      await dartFile.create(recursive: true);
      return dartFile;
    }
  }

  Future<File> createFileForOffline(LocalFile file) async {
    if (!Platform.isIOS) await getStoragePermissions();

    final Directory dir = await getApplicationDocumentsDirectory();
    final File dartFile = new File("${dir.path}/offline/${file.guid}_${file.name}");
    if (await dartFile.exists()) {
      return dartFile;
    } else {
      await dartFile.create(recursive: true);
      return dartFile;
    }
  }

//  Future<File> saveFileForShare(List<int> fileBytes, LocalFile file) async {
//    final Directory dir = await getTemporaryDirectory();
//    File tempFileForShare = new File("${dir.path}/share/${file.name}");
//    if (!await tempFileForShare.exists()) {
//      await tempFileForShare.create(recursive: true);
//      await tempFileForShare.writeAsBytes(fileBytes);
//    }
//    return tempFileForShare;
//  }

//  Future<File> cacheFile(List<int> fileBytes, LocalFile file) async {
//    final Directory dir = await getTemporaryDirectory();
//    File cachedFile = new File("${dir.path}/files/${file.guid}");
//    if (!await cachedFile.exists()) {
//      await cachedFile.create(recursive: true);
//      await cachedFile.writeAsBytes(fileBytes);
//    }
//    return cachedFile;
//  }

  // if file not found returns null
//  Future<File> getFileFromCache(LocalFile fileObj) async {
//    File storedFile;
//
//    final tempDir = await getTemporaryDirectory();
//    final tempFolder = Directory("${tempDir.path}/files");
//    final folderExists = await tempFolder.exists();
//    if (folderExists) {
//      final itemsInTemp = await tempFolder.list().toList();
//
//      itemsInTemp.forEach((file) async {
//        if (file.path.contains(fileObj.guid) && file is File) {
//          if (file.lengthSync() == fileObj.size) {
//            storedFile = file;
//          }
//        }
//      });
//    }
//    return storedFile;
//  }

  Future<void> deleteFilesFromCache([List<LocalFile> files]) async {
    final Directory dir = await getTemporaryDirectory();
    if (files != null) {
      for (final file in files) {
        File cachedFile = new File("${dir.path}/images/${file.guid}");
        if (cachedFile.existsSync()) {
          await cachedFile.delete(recursive: true);
        }
      }
    } else {
      final cacheDir = new Directory("${dir.path}/files_to_delete");
      if (cacheDir.existsSync()) {
        await cacheDir.delete(recursive: true);
      }
    }
  }

  Future<List> encryptFile(File file) async {
    final fileBytes = await file.readAsBytes();
//    final chunkedList = _chunk(fileBytes);
    Directory appDocDir = await getApplicationDocumentsDirectory();
    final encryptedFile = new File(
      '${appDocDir.path}/temp_encrypted_files/${FileUtils.getFileNameFromPath(file.path)}',
    );
    await encryptedFile.create(recursive: true);

    final key = prefixEncrypt.Key.fromBase16(AppStore.settingsState.currentKey);
    final iv = IV.fromSecureRandom(16);
    try {
//      final List<dynamic> encryptedData = await _platformEncryptionChannel.invokeMethod('encrypt',
//          [Base64Encoder().convert(fileBytes), key.base64, iv.base64]);
//      // cast to List<int> (mostly for iOS)
//      await encryptedFile.writeAsBytes(new List<int>.from(encryptedData));
//      return [encryptedFile, iv.base16];
    } on PlatformException catch (e) {
      print("PlatformException: $e");
      throw CustomException("This device is unable to encrypt/decrypt files");
    }
//    IV nextVector = iv;
//    for (final List<int> chunk in chunkedList) {
//      final padding =
//          chunkedList.indexOf(chunk) == chunkedList.length - 1 ? "PKCS7" : null;
//      final encrypter =
//          Encrypter(AES(key, mode: AESMode.cbc, padding: padding));
//      final args = {
//        "encrypter": encrypter,
//        "fileBytes": chunk,
//        "iv": nextVector
//      };
//      final result = await compute(_encrypt, args);
//      await encryptedFile.writeAsBytes(result.bytes, mode: FileMode.append);
//
//      nextVector = IV(Uint8List.fromList(
//          result.bytes.sublist(result.bytes.length - 16, result.bytes.length)));
//    }
//
//    return [encryptedFile, iv.base16];
  }

// updateDecryptionProgress returns decrypted chunk index and total # of chunks
//  Future<void> decryptFile({
//    @required LocalFile file,
//    @required List<int> fileBytes,
//    @required Function(List<int>) getChunk,
//    Function(double) updateDecryptionProgress,
//  }) async {
//    final key = prefixEncrypt.Key.fromBase16(AppStore.settingsState.currentKey);
//    IV iv = IV.fromBase16(file.initVector);
//
//    try {
//
//      // TODO VO: broken
////      cryptor.decrypt(
////        fileBytes: fileBytes,
////        keyBase64: key.base64,
////        ivBase64: iv.base64,
////        updateProgress: updateDecryptionProgress,
////        getChunk: getChunk,
////      );
//    } on PlatformException catch (e) {
//      print("PlatformException: $e");
//      throw CustomException(
//          "This device is unable to encrypt/decrypt the file");
//    } catch (err) {
//      throw CustomException(err.message ?? "Unknown error");
//    }

// OLD DART ENCRYPTION. VERY SLOW!

//    List<int> encryptedFileBytes = fileBytes;
//    final List<int> decryptedFileBytes = new List();
//    final chunkedList = _chunk(encryptedFileBytes);
//    final chunksToSort = new List<Future<DecryptionResult>>();
//
//    chunkedList.forEach((chunk) async {
//      final i = chunkedList.indexOf(chunk);
//      final padding =
//          chunkedList.indexOf(chunk) == chunkedList.length - 1 ? "PKCS7" : null;
//      final encrypter =
//          Encrypter(AES(key, mode: AESMode.cbc, padding: padding));
//      final encrypted = Encrypted(Uint8List.fromList(chunk));
//      final args = DecryptionArgs(encrypter, encrypted, iv, i);
//      final result = compute(_decrypt, args);
//      final newVector = chunk.sublist(chunk.length - 16, chunk.length);
//
//      iv = IV(Uint8List.fromList(newVector));
//      chunksToSort.add(result);
//    });
//
//    // decrypt chunks in parallel
//    final decryptionResults = new List<DecryptionResult>();
//    final decryptionStream = Stream.fromFutures(chunksToSort);
//    int index = 1;
//    await for (final res in decryptionStream) {
//      if (updateDecryptionProgress != null) {
//        updateDecryptionProgress(index, chunkedList.length);
//      }
//      decryptionResults.add(res);
//      index++;
//    }
//
//    decryptionResults.sort((a, b) => a.index.compareTo(b.index));
//    decryptionResults
//        .forEach((result) => decryptedFileBytes.addAll(result.bytes));
//
//    return decryptedFileBytes;
}

//  List _chunk(list) => list.toList().isEmpty
//      ? list.toList()
//      : ([list.take(chunkSize).toList()]
//        ..addAll(_chunk(list.skip(chunkSize).toList())));

//  static Encrypted _encrypt(Map args) {
//    return args["encrypter"].encryptBytes(args["fileBytes"], iv: args["iv"]);
//  }
//
//  static Future<DecryptionResult> _decrypt(DecryptionArgs args) async {
//    final decryptedBytes =
//        args.encrypter.decryptBytes(args.encrypted, iv: args.iv);
//    return new DecryptionResult(args.chunkIndex, decryptedBytes);
//  }
//}

//class DecryptionArgs {
//  final Encrypter encrypter;
//  final Encrypted encrypted;
//  final IV iv;
//  final int chunkIndex;
//
//  DecryptionArgs(this.encrypter, this.encrypted, this.iv, this.chunkIndex);
//}
//
//class DecryptionResult {
//  final List<int> bytes;
//  final int index;
//
//  DecryptionResult(this.index, this.bytes);
//}
