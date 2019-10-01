import 'dart:convert';
import 'dart:io';

import 'package:aurorafiles/database/app_database.dart';
import 'package:aurorafiles/modules/app_store.dart';
import 'package:aurorafiles/modules/files/repository/files_api.dart';
import 'package:aurorafiles/modules/files/repository/files_local_storage.dart';
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
    downloadProgress = 0.0;

    // get file contents
    if (AppStore.filesState.isOfflineMode) {
      final localFile = new File(file.localPath);
      fileContent = await localFile.readAsBytes();
      downloadProgress = 1.0;
    } else {
      fileContent = await _filesApi.downloadFile(
        file.viewUrl,
        updateProgress: (int bytesLoaded) {
          downloadProgress = 100 / file.size * bytesLoaded / 100;
        },
      );
    }
    // if encrypted - decrypt
    if (file.initVector != null) {
      fileBytes = await _filesLocal.decryptFile(
        file: file,
        fileBytes: fileContent,
      );
    } else {
      fileBytes = fileContent;
    }

    downloadProgress = null;
  }

  Future<void> getPreviewImage() async {
    downloadProgress = 0.0;
    // try to retrieve the file from cache
    fileBytes = await _filesLocal.getFileFromCache(file);
    // if no cache, get file
    if (fileBytes == null) {
      await _getPreviewFile();
    } else {
      downloadProgress = 1.0;
    }
    if (!AppStore.filesState.isOfflineMode) {
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
