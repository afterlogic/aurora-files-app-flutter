import 'package:flutter/widgets.dart';

class FileToDelete {
  final String path;
  final String name;
  final bool isFolder;

  FileToDelete({
    required this.path,
    required this.name,
    required this.isFolder,
  });

  Map<String, dynamic> toMap() {
    return {
      "Path": path,
      "Name": name,
      "IsFolder": isFolder,
    };
  }
}
