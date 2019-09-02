import 'package:flutter/material.dart';

import 'state/files_state.dart';

class FilesRoute {
  static const name = "files";
}

class FilesScreenArguments {
  final String path;
  final FilesState filesState;

  FilesScreenArguments({@required this.filesState, @required this.path});
}
