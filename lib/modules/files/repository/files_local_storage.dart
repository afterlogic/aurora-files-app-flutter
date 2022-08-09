import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';

import 'package:aurorafiles/database/app_database.dart';
import 'package:aurorafiles/di/di.dart';
import 'package:aurorafiles/models/processing_file.dart';
import 'package:aurorafiles/modules/settings/repository/pgp_key_util.dart';
import 'package:aurorafiles/utils/custom_exception.dart';
import 'package:aurorafiles/utils/download_directory.dart';
import 'package:aurorafiles/utils/permissions.dart';
import 'package:crypto_stream/algorithm/aes.dart';
import 'package:encrypt/encrypt.dart';
import 'package:encrypt/encrypt.dart' as prefixEncrypt;
import 'package:file_picker/file_picker.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share/share.dart';

class FilesLocalStorage {
  Aes aes = DI.get();

  Future<File?> pickFiles({FileType? type, String? extension}) async {
    final result = await FilePicker.platform.pickFiles(
      type: type ?? FileType.any,
      allowedExtensions: extension != null ? [extension] : null,
    );
    if (result?.files.isNotEmpty != true) return null;
    return File(result?.files.first.path ?? '');
  }

  // is used to download files on iOS
  Future<void> shareFile(File? storedFile, LocalFile file, Rect rect) async {
    String fileType;
    if (file.contentType.startsWith("image"))
      fileType = "image";
    else if (file.contentType.startsWith("video"))
      fileType = "video";
    else
      fileType = "file";

    await Share.shareFiles(
      [storedFile?.path ?? file.path],
      mimeTypes: [fileType],
      sharePositionOrigin: rect,
    );
  }

  Future<void> openFileWith(File? file) async {
//    final tempFileForShare = await cacheFile(fileBytes, file);
    await OpenFile.open(file?.path);
  }

//  Future<String> saveFileInDownloads(
//      List<int> fileBytes, LocalFile file) async {
//    if (!PlatformOverride.isIOS) await getStoragePermissions();
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

    final Directory dir = await getDownloadDirectory();
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
//    if (file.initVector != null) {
//      throw CustomException("Cannot cache encrypted image contents");
//    }
    if (!Platform.isIOS) await getStoragePermissions();

    final Directory dir = await getTemporaryDirectory();
    final File dartFile =
        new File("${dir.path}/images/${file.guid}_${file.name}");
    final bool exist = await dartFile.exists();
    if (exist) {
      return dartFile;
    } else {
      await dartFile.create(recursive: true);
      return dartFile;
    }
  }

  Future<File> createFileForOffline(LocalFile file) async {
    if (!Platform.isIOS) await getStoragePermissions();

    final Directory dir = await getApplicationDocumentsDirectory();
    final dartFile = new File(
        "${dir.path}/offline${file.path + (file.path.isNotEmpty ? "/" : "")}${file.guid}_${file.name}");
    if (await dartFile.exists()) {
      return dartFile;
    } else {
      await dartFile.create(recursive: true);
      return dartFile;
    }
  }

  // if file not found returns null
  Future<File?> copyFromCache(LocalFile file, String pathToCopyTo) async {
    final Directory tempDir = await getTemporaryDirectory();
    final splitDir = pathToCopyTo.split("/");
    splitDir.removeLast();
    final dir = Directory(splitDir.join("/"));
    if (await dir.exists() != true) dir.create(recursive: true);
    File cachedFile = new File("${tempDir.path}/files_to_delete/${file.guid}");
    if (await cachedFile.exists()) {
      final copiedFile = await cachedFile.copy(pathToCopyTo);
      return copiedFile;
    }

    cachedFile = new File("${tempDir.path}/files_to_delete/${file.name}");
    if (await cachedFile.exists()) {
      final copiedFile = await cachedFile.copy(pathToCopyTo);
      return copiedFile;
    }

    cachedFile = new File("${tempDir.path}/images/${file.guid}_${file.name}");
    if (await cachedFile.exists()) {
      final copiedFile = await cachedFile.copy(pathToCopyTo);
      return copiedFile;
    }
    // else
    return null;
  }

  Future<void> deleteFilesFromCache(
      {List<LocalFile>? files, bool deleteCachedImages = false}) async {
    final Directory dir = await getTemporaryDirectory();
    if (files != null) {
      for (final file in files) {
        File cachedFile = new File("${dir.path}/images/${file.guid}");
        if (cachedFile.existsSync()) {
          await cachedFile.delete(recursive: true);
        }
      }
    } else {
      if (deleteCachedImages == true) {
        final cacheDir = new Directory(dir.path);
        if (cacheDir.existsSync()) {
          await cacheDir.delete(recursive: true);
        }
      } else {
        final cacheDir = new Directory("${dir.path}/files_to_delete");
        if (cacheDir.existsSync()) {
          await cacheDir.delete(recursive: true);
        }
      }
    }
  }

  Future<File> downloadOffline(
    LocalFile file,
    ProcessingFile processingFile,
    String? keyPassword,
  ) async {
    final offlineFile = new File(file.localPath);
    if (!await offlineFile.exists()) {
      throw CustomException(
          "The file does not exist, please remove it and set offline when you are online again.");
    }
    await processingFile.fileOnDevice.create(recursive: true);

    if (file.initVector == null) {
      await offlineFile.copy(processingFile.fileOnDevice.path);
      return processingFile.fileOnDevice;
    } else {
      final decryptedFile = await _decryptFile(
        processingFile,
        offlineFile,
        file.encryptedDecryptionKey ?? '',
        keyPassword ?? '',
      );
      return decryptedFile;
    }
  }

  Future<PreparedForShare> shareOffline(
    LocalFile file,
    ProcessingFile processingFile,
    String? keyPassword,
  ) async {
    File offlineFile = new File(file.localPath);
    if (!await offlineFile.exists()) {
      throw CustomException(
          "The file does not exist, please remove it and set offline when you are online again.");
    }
    if (file.initVector != null && file.encryptedDecryptionKey != null) {
      offlineFile = await _decryptFile(
        processingFile,
        offlineFile,
        file.encryptedDecryptionKey ?? '',
        keyPassword ?? '',
      );
    }

    return PreparedForShare(offlineFile, file);
  }

  Future<File> _decryptFile(
    ProcessingFile processingFile,
    File encryptedFile,
    String encryptedDecryptionKey,
    String password,
  ) async {
    assert(processingFile.ivBase64 != null);

    await processingFile.fileOnDevice.create(recursive: true);

    final key = prefixEncrypt.Key.fromBase16(await PgpKeyUtil.instance
        .userDecrypt(encryptedDecryptionKey, password));

    List<int> fileBytesBuffer = [];
    int progress = 0;

    await for (final contents in encryptedFile.openRead()) {
      List<int> contentsForCurrent;
      // by default all the contents received go to contentsForNext which then will be added to the buffer
      // if current buffer + contentsForNext exceed Aes.chunkMaxSize, contentsForNext will be rewritten
      List<int> contentsForNext = contents;

      // if this is the final part that forms a chunk
      if (Aes.chunkMaxSize <= fileBytesBuffer.length + contents.length) {
        contentsForCurrent =
            contents.sublist(0, Aes.chunkMaxSize - fileBytesBuffer.length);

        contentsForNext = contents.sublist(
            Aes.chunkMaxSize - fileBytesBuffer.length, contents.length);

        fileBytesBuffer.addAll(contentsForCurrent);

        final decrypted = await aes.decrypt(fileBytesBuffer, key.base64,
            processingFile.ivBase64 ?? '', false) as List<int>;
        await processingFile.fileOnDevice
            .writeAsBytes(decrypted, mode: FileMode.append);
        // update vector with the last 16 bytes of the chunk
        final newVector = fileBytesBuffer.sublist(
            fileBytesBuffer.length - 16, fileBytesBuffer.length);
        processingFile.ivBase64 = IV(Uint8List.fromList(newVector)).base64;

        // flush the buffer
        fileBytesBuffer = [];
      }
      fileBytesBuffer.addAll(contentsForNext);
      // the callback to update the UI download progress
      // update progress
      progress += contents.length;
      final num = 100 / processingFile.size * progress / 100;
      processingFile.updateProgress(num);
    }
    if (fileBytesBuffer.isNotEmpty) {
      final decrypted = await aes.decrypt(
              fileBytesBuffer, key.base64, processingFile.ivBase64 ?? '', true)
          as List<int>;
      await processingFile.fileOnDevice
          .writeAsBytes(decrypted, mode: FileMode.append);
    }

    return processingFile.fileOnDevice;
  }
}

class PreparedForShare {
  File? file;
  LocalFile localFile;

  PreparedForShare(this.file, this.localFile);
}
//  Future<List> encryptFile(File file) async {
//    final fileBytes = await file.readAsBytes();
////    final chunkedList = _chunk(fileBytes);
//    Directory appDocDir = await getApplicationDocumentsDirectory();
//    final encryptedFile = new File(
//      '${appDocDir.path}/temp_encrypted_files/${FileUtils.getFileNameFromPath(file.path)}',
//    );
//    await encryptedFile.create(recursive: true);
//
//    final key = prefixEncrypt.Key.fromBase16(AppStore.settingsState.currentKey);
//    final iv = IV.fromSecureRandom(16);
//    try {
////      final List<dynamic> encryptedData = await _platformEncryptionChannel.invokeMethod('encrypt',
////          [Base64Encoder().convert(fileBytes), key.base64, iv.base64]);
////      // cast to List<int> (mostly for iOS)
////      await encryptedFile.writeAsBytes(new List<int>.from(encryptedData));
////      return [encryptedFile, iv.base16];
//    } on PlatformException catch (e) {
//      print("PlatformException: $e");
//      throw CustomException("This device is unable to encrypt/decrypt files");
//    }
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

// updateDecryptionProgress returns decrypted chunk index and total # of chunks
//  Future<void> decryptFile({
//    required LocalFile file,
//    required List<int> fileBytes,
//    required Function(List<int>) getChunk,
//    Function(double) updateDecryptionProgress,
//  }) async {
//    final key = prefixEncrypt.Key.fromBase16(AppStore.settingsState.currentKey);
//    IV iv = IV.fromBase16(file.initVector);
//
//    try {
//
//
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
//}

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
