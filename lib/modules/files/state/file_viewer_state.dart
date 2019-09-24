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

  List<int> fileBytes;

  Future<void> _getPreviewFile() async {
    downloadProgress = 0.0;
    if (AppStore.filesState.isOfflineMode) {
      final localFile = new File(file.localPath);
      fileBytes = await localFile.readAsBytes();
      downloadProgress = 1.0;
    } else {
      fileBytes = await _filesApi.downloadFileForPreview(
        file.viewUrl,
        updateProgress: (int bytesLoaded) {
          downloadProgress = 100 / file.size * bytesLoaded / 100;
          if (downloadProgress >= 1.0 && file.initVector != null) {
            downloadProgress = null;
          }
        },
      );
    }
  }

  Future<void> getFileFromCache() async {
    downloadProgress = 0.0;
    fileBytes = await _filesLocal.getFileFromCache(file);
    downloadProgress = 1.0;
  }

  Future<void> getPreviewImage() async {
    await _getPreviewFile();
    _filesLocal.cacheFile(fileBytes, file);
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

  Future<List<int>> decryptFile() async {
    await _getPreviewFile();
    return _filesLocal.decryptFile(file: file, fileBytes: fileBytes);
  }
}
