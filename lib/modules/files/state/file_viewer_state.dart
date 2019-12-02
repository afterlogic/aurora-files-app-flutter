import 'dart:io';

import 'package:aurorafiles/di/di.dart';
import 'package:domain/api/file_worker/file_load_worker_api.dart';
import 'package:domain/api/network/files_network_api.dart';
import 'package:domain/model/bd/local_file.dart';
import 'package:aurorafiles/modules/app_store.dart';
import 'package:aurorafiles/modules/files/repository/files_local_storage.dart';
import 'package:aurorafiles/utils/file_content_type.dart';
import 'package:domain/model/data/processing_file.dart';
import 'package:domain/model/data/recipient.dart';
import 'package:flutter/services.dart';
import 'package:mobx/mobx.dart';

part 'file_viewer_state.g.dart';

class FileViewerState = _FileViewerState with _$FileViewerState;

abstract class _FileViewerState with Store {
  final FilesNetworkApi _filesApi = DI.get();
  final FileLoadWorkerApi _fileLoad = DI.get();
  final _filesLocal = new FilesLocalStorage();

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
        processingFile = new ProcessingFile.fill(
          guid: file.guid,
          name: file.name,
          size: file.size,
          fileOnDevice: fileToView,
          processingType: getFileType(file) == FileType.image
              ? ProcessingType.cacheImage
              : ProcessingType.cacheToDelete,
        );

        // ignore: cancel_subscriptions
        final sub = (await _fileLoad.downloadFile(
          file.viewUrl,
          file,
          AppStore.settingsState.currentKey,
          processingFile,
        ))
            .listen((progress) => downloadProgress = progress, onDone: () {
          fileWithContents = fileToView;
          downloadProgress = null;
          processingFile = null;
          if (onDownloadEnd != null) onDownloadEnd(fileToView);
        }, onError: (err) {
          processingFile = null;
        }, cancelOnError: true);

        processingFile.subscription = sub;
      }
    }
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
}
