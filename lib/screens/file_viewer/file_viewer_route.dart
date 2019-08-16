import 'package:aurorafiles/screens/files/state/files_state.dart';
import 'package:flutter/widgets.dart';

class FileViewerRoute {
  static const name = "files/file_viewer";
}

class FileViewerScreenArguments {
  // TODO fix type
  final Map<String, dynamic> file;
  final FilesState filesState;

  FileViewerScreenArguments({@required this.filesState, @required this.file});
}
