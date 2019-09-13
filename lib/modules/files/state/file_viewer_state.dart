import 'dart:convert';

import 'package:aurorafiles/database/app_database.dart';
import 'package:aurorafiles/modules/files/repository/files_api.dart';
import 'package:mobx/mobx.dart';

part 'file_viewer_state.g.dart';

class FileViewerState = _FileViewerState with _$FileViewerState;

abstract class _FileViewerState with Store {
  final _filesApi = new FilesApi();

  LocalFile file;

  @observable
  String previewText;

  @observable
  double downloadProgress;

  void onGetPreviewText() async {
    downloadProgress = 0.0;
    final fileBytes = await _filesApi.downloadFileForPreview(file.downloadUrl,
        updateProgress: (int bytesLoaded) {
      downloadProgress = 100 / file.size * bytesLoaded / 100;
    });

    Future.delayed(Duration(milliseconds: 60), () => previewText = Utf8Codec().decode(fileBytes));
  }
}
