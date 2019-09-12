import 'package:aurorafiles/database/app_database.dart';
import 'package:aurorafiles/modules/files/state/files_page_state.dart';
import 'package:aurorafiles/modules/files/state/files_state.dart';
import 'package:flutter/widgets.dart';

class FileViewerRoute {
  static const name = "files/file_viewer";
}

class FileViewerScreenArguments {
  final LocalFile file;
  final FilesState filesState;
  final FilesPageState filesPageState;

  FileViewerScreenArguments({
    @required this.filesState,
    @required this.filesPageState,
    @required this.file,
  });
}