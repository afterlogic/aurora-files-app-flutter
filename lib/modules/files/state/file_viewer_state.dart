import 'dart:convert';

import 'package:aurorafiles/database/app_database.dart';
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
    fileBytes = await _filesApi.downloadFileForPreview(
      file.downloadUrl,
      updateProgress: (int bytesLoaded) {
        downloadProgress = 100 / file.size * bytesLoaded / 100;
        if (downloadProgress >= 1.0 && file.initVector != null) {
          downloadProgress = null;
        }
      },
    );
  }

  Future<void> onGetPreviewImage() async {
    return _getPreviewFile();
  }

  Future<String> onGetPreviewText() async {
    await _getPreviewFile();

    String previewText;
    // to give some time for progress indicator to show filled state
    await Future.delayed(Duration(milliseconds: 60),
        () => previewText = Utf8Codec().decode(fileBytes));
    return previewText;
  }

  Future<List<int>> onDecryptFile() async {
    await _getPreviewFile();
    return _filesLocal.decryptFile(file: file, fileBytes: fileBytes);
  }

//  void launchURL({Function(String) onError}) async {
//    String url = "${AppStore.authState.hostName}/${file.downloadUrl}/view";
//    if (url.startsWith("http://")) url.replaceFirst("http", "https");
//
//    if (await canLaunch(url)) {
//      await launch(url, headers: getHeader());
//    } else {
//      onError("Could not launch $url");
//    }
//  }
}