import 'package:flutter/material.dart';

import 'state/files_state.dart';

class FilesRoute {
  static const name = "files";
}

class FilesScreenArguments {
  final String path;

  FilesScreenArguments({@required this.path});
}
