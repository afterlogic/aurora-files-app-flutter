import 'package:domain/model/bd/local_file.dart';

abstract class FileWorkerApi {
  getFilesAtPath(String pagePath);

  searchFiles(String pagePath, String searchPattern);

  deleteFiles(List<LocalFile> filesToDeleteLocally);

  Future deleteAll(List<LocalFile> list);

  getStorages();
}
