import 'package:flutter/material.dart';

class FilesRoute {
  static const name = "files";
}

class FilesScreenArguments {
  final String path;
  final bool isZip;

  FilesScreenArguments({this.isZip = false, @required this.path, });
}
