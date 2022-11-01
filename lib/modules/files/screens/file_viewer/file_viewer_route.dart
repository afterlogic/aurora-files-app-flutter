import 'dart:io';

import 'package:aurorafiles/database/app_database.dart';
import 'package:aurorafiles/modules/files/state/files_page_state.dart';
import 'package:aurorafiles/modules/files/state/files_state.dart';

class FileViewerRoute {
  static const name = "file_viewer";
}

class FileViewerScreenArguments {
  final LocalFile file;
  final FilesState filesState;
  final FilesPageState filesPageState;
  final File? offlineFile;

  FileViewerScreenArguments({
    required this.file,
    required this.filesState,
    required this.filesPageState,
    this.offlineFile,
  });
}
