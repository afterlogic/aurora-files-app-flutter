import 'package:aurorafiles/screens/files/state/files_state.dart';
import 'package:flutter/cupertino.dart';

class FilesRoute {
  static const name = "files";
}

class FilesScreenArguments {
  final String path;
  final FilesState filesState;

  FilesScreenArguments({@required this.filesState, @required this.path});
}
