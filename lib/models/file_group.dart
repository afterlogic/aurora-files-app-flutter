import 'package:aurorafiles/database/app_database.dart';

class FileGroup {
  final String path;
  final List<LocalFile> files;

  FileGroup({
    required this.path,
    required this.files,
  });

  @override
  String toString() {
    final fileNames = files.map((e) => e.name).join(', ');
    return 'Path: $path, Files: $fileNames';
  }
}
