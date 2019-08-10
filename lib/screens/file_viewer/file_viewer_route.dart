import 'package:flutter/widgets.dart';

class FileViewerRoute {
  static const name = "files/file_viewer";
}

class FileViewerScreenArguments {
  // TODO fix type
  final Map<String, dynamic> file;

  FileViewerScreenArguments({@required this.file});
}
