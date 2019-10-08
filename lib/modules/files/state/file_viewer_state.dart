import 'dart:convert';
import 'dart:io';

import 'package:aurorafiles/database/app_database.dart';
import 'package:aurorafiles/modules/app_store.dart';
import 'package:aurorafiles/modules/files/repository/files_api.dart';
import 'package:aurorafiles/modules/files/repository/files_local_storage.dart';
import 'package:flutter/services.dart';
import 'package:mobx/mobx.dart';

part 'file_viewer_state.g.dart';

class FileViewerState = _FileViewerState with _$FileViewerState;

abstract class _FileViewerState with Store {
  final _filesApi = new FilesApi();
  final _filesLocal = new FilesLocalStorage();

  LocalFile file;

  @observable
  double downloadProgress;

  @observable
  double decryptionProgress;

  List<int> fileBytes;

  Future<void> _getPreviewFile() async {
    List<int> fileContent;
    final progressDivider = file.initVector == null ? 1 : 2;
    downloadProgress = 0.0;

    // get file contents
    if (AppStore.filesState.isOfflineMode) {
      final localFile = new File(file.localPath);
      fileContent = await localFile.readAsBytes();
      downloadProgress = 1.0 / progressDivider;
    } else {

      // TODO VO: broken
//      fileContent = await _filesApi.downloadFile(
//        file.viewUrl,
//        updateProgress: (int bytesLoaded) {
//          downloadProgress =
//              100 / file.size * bytesLoaded / 100 / progressDivider;
//        },
//      );
    }
    // if encrypted - decrypt
    if (file.initVector != null) {
      downloadProgress = 0.5;
      await _filesLocal.decryptFile(
        file: file,
        fileBytes: fileContent,
        updateDecryptionProgress: (progress) =>
            downloadProgress = progress / 2 + 0.5, getChunk: (List a) {},
      );
    } else {
      fileBytes = fileContent;
    }

    downloadProgress = null;
  }

  Future<void> getPreviewImage(Function(String) onError) async {
    downloadProgress = 0.0;
    // try to retrieve the file from cache
    fileBytes = await _filesLocal.getFileFromCache(file);
    // if no cache, get file
    if (fileBytes == null) {
      try {
        await _getPreviewFile();
      } catch (err) {
        onError(err is PlatformException ? err.message : err.toString());
      }
    } else {
      downloadProgress = 1.0;
    }
    if (!AppStore.filesState.isOfflineMode && file.initVector == null) {
      _filesLocal.cacheFile(fileBytes, file);
    }
  }

  Future<String> getPreviewText() async {
    await _getPreviewFile();

    String previewText;
    // to give some time for progress indicator to show filled state
    await Future.delayed(Duration(milliseconds: 60),
        () => previewText = Utf8Codec().decode(fileBytes));
    return previewText;
  }

  Future<void> onOpenPdf() async {
    if (fileBytes == null) await _getPreviewFile();

    _filesLocal.openFileWith(fileBytes, file);
  }
}
