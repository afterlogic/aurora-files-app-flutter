import 'dart:io';

import 'package:aurorafiles/database/app_database.dart';
import 'package:aurorafiles/models/processing_file.dart';
import 'package:aurorafiles/models/recipient.dart';
import 'package:aurorafiles/models/secure_link.dart';
import 'package:aurorafiles/models/storage.dart';
import 'package:aurorafiles/modules/app_store.dart';
import 'package:aurorafiles/modules/files/repository/files_api.dart';
import 'package:aurorafiles/modules/files/repository/files_local_storage.dart';
import 'package:aurorafiles/modules/files/state/files_state.dart';
import 'package:aurorafiles/utils/file_content_type.dart';
import 'package:aurorafiles/utils/file_utils.dart';
import 'package:flutter/services.dart';
import 'package:meta/meta.dart';
import 'package:mobx/mobx.dart';
import 'package:uuid/uuid.dart';

part 'file_viewer_state.g.dart';

class FileViewerState = _FileViewerState with _$FileViewerState;

abstract class _FileViewerState with Store {
  final _filesApi = new FilesApi();
  final _filesLocal = new FilesLocalStorage();
  FilesState fileState;

  Storage storage;
  LocalFile file;

  @observable
  double downloadProgress;

  File fileWithContents;

  ProcessingFile processingFile;

  Future<void> _getPreviewFile(File fileToView,
      {Function(File) onDownloadEnd}) async {
    downloadProgress = 0.0;

    // get file contents
    if (AppStore.filesState.isOfflineMode) {
      fileWithContents = new File(file.localPath);
      if (onDownloadEnd != null) onDownloadEnd(fileToView);
      downloadProgress = 1.0;
    } else {
      if (await fileToView.length() > 0) {
        fileWithContents = fileToView;
        downloadProgress = null;
        if (onDownloadEnd != null) onDownloadEnd(fileToView);
      } else {
        // view file are not added to the processingFiles list as of now
        processingFile = new ProcessingFile(
          guid: file.guid,
          name: file.name,
          size: file.size,
          fileOnDevice: fileToView,
          processingType: getFileType(file) == FileType.image
              ? ProcessingType.cacheImage
              : ProcessingType.cacheToDelete,
        );

        // ignore: cancel_subscriptions
        final sub = await _filesApi.getFileContentsFromServer(
            file.viewUrl, file, processingFile, false,
            onSuccess: (_) {
              fileWithContents = fileToView;
              downloadProgress = null;
              processingFile = null;
              if (onDownloadEnd != null) onDownloadEnd(fileToView);
            },
            updateViewerProgress: (progress) => downloadProgress = progress,
            onError: (err) {
              processingFile = null;
            });
        processingFile.subscription = sub;
      }
    }
    // if encrypted - decrypt
//    if (file.initVector != null) {
//      downloadProgress = 0.5;
//      await _filesLocal.decryptFile(
//        file: file,
//        fileBytes: fileContent,
//        updateDecryptionProgress: (progress) =>
//            downloadProgress = progress / 2 + 0.5, getChunk: (List a) {},
//      );
//    } else {
//      fileBytes = fileContent;
//    }
  }

  Future<void> getPreviewImage(Function(String) onError) async {
    downloadProgress = 0.0;
    // try to retrieve the file from cache
    // if no cache, get file
    if (fileWithContents == null) {
      try {
        final File imageToView = await _filesLocal.createImageCacheFile(file);
        await _getPreviewFile(imageToView);
      } catch (err) {
        onError(err is PlatformException ? err.message : err.toString());
      }
    } else {
      downloadProgress = 1.0;
    }
  }

  Future<void> getPreviewText(Function(String) getText) async {
    downloadProgress = 0.0;
    final File textToView = await _filesLocal.createTempFile(file);
    await _getPreviewFile(textToView, onDownloadEnd: (File storedFile) async {
      String previewText = await fileWithContents.readAsString();
      getText(previewText);
    });
  }

  Future<void> onOpenPdf() async {
    final File pdfToView =
        await _filesLocal.createTempFile(file, useName: true);
    await _getPreviewFile(pdfToView, onDownloadEnd: (File storedFile) {
      fileWithContents = storedFile;
      _filesLocal.openFileWith(fileWithContents);
    });
  }

  Future<List<Recipient>> getRecipient() async {
    return _filesApi.getRecipient();
  }

  Future<void> uploadSecureFile(
      {@required File file,
      @required Function(ProcessingFile) onUploadStart,
      @required Function() onSuccess,
      @required Function(String) onError,
      @required bool passwordEncryption,
      @required String encryptionRecipientEmail,
      @required String extend}) {
    return fileState.uploadFile(
        passwordEncryption: passwordEncryption,
        encryptionRecipientEmail: encryptionRecipientEmail,
        name: this.file.name + extend,
        shouldEncrypt: false,
        file: file,
        path: this.file.path,
        onUploadStart: onUploadStart,
        onSuccess: onSuccess,
        onError: onError);
  }

  Future<void> createPublicLink({
    @required File file,
    @required Function(String) onSuccess,
    @required Function(String) onError,
    @required String extend,
  }) async {
    final size = await file.length();
    return fileState.onGetPublicLink(
        name: this.file.name + extend,
        size: size,
        isFolder: false,
        path: this.file.path,
        onSuccess: onSuccess,
        onError: onError);
  }

  Future<void> createSecureLink({
    @required File file,
    @required Function(SecureLink) onSuccess,
    @required Function(String) onError,
    @required String extend,
  }) async {
    final size = await file.length();
    return fileState.onGetSecureLink(
        name: this.file.name + extend,
        size: size,
        isFolder: false,
        path: this.file.path,
        onSuccess: onSuccess,
        onError: onError);
  }
}
