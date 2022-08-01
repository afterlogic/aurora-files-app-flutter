class FilesRoute {
  static const name = "files";
}

class FilesScreenArguments {
  final String path;
  final bool isZip;

  FilesScreenArguments({this.isZip = false, this.path = ""});
}
