import 'dart:io';

String getFileExtension(File file) {
  final fileName = file.path.split(Platform.pathSeparator).last;
  return fileName.split(".").last;
}

Future deleteIfExist(File file) async {
  if (await file.exists()) await file.delete();
}
