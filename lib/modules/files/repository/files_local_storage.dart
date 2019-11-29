import 'dart:async';
import 'dart:io';
import 'package:domain/model/bd/local_file.dart';
import 'package:aurorafiles/models/processing_file.dart';
import 'package:aurorafiles/utils/custom_exception.dart';
import 'package:aurorafiles/utils/permissions.dart';
import 'package:downloads_path_provider/downloads_path_provider.dart';
import 'package:file_picker/file_picker.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_extend/share_extend.dart';

class FilesLocalStorage {
  Future<File> pickFiles({FileType type, String extension}) {
    return FilePicker.getFile(type: type, fileExtension: extension);
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
        "${dir.path}/files_to_delete/${useName == true ? file.name : file
            .guid}");
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
    final File dartFile =
    new File("${dir.path}/images/${file.guid}_${file.name}");
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
    final dartFile = new File("${dir.path}/offline/${file.guid}_${file.name}");
    if (await dartFile.exists()) {
      return dartFile;
    } else {
      await dartFile.create(recursive: true);
      return dartFile;
    }
  }

  // if file not found returns null
  Future<File> copyFromCache(LocalFile file, String pathToCopyTo) async {
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
      {List<LocalFile> files, bool deleteCachedImages = false}) async {
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

  Future<File> downloadOffline(LocalFile file,
      ProcessingFile processingFile) async {
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
      final decryptedFile = await _decryptFile(processingFile, offlineFile);
      return decryptedFile;
    }
  }

  Future<PreparedForShare> shareOffline(LocalFile file,
      ProcessingFile processingFile) async {
    File offlineFile = new File(file.localPath);
    if (!await offlineFile.exists()) {
      throw CustomException(
          "The file does not exist, please remove it and set offline when you are online again.");
    }
    if (file.initVector != null) {
      offlineFile = await _decryptFile(
          processingFile, offlineFile, processingFile.fileOnDevice);
    }

    return PreparedForShare(offlineFile, file);
  }
//
//  Future<File> _decryptFile(ProcessingFile processingFile,
//      File encryptedFile,
//      File decryptedFile,)

}

class PreparedForShare {
  final File file;
  final LocalFile localFile;

  PreparedForShare(this.file, this.localFile);
}
