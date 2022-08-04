import 'package:flutter/widgets.dart';

class FileToMove {
  final String type;
  final String path;
  final String name;
  final bool isFolder;

  FileToMove({
    required this.type,
    required this.path,
    required this.name,
    required this.isFolder,
  });

  Map<String, dynamic> toMap() {
    return {
      "FromType": type,
      "FromPath": path,
      "Name": name,
      "IsFolder": isFolder,
    };
  }
}