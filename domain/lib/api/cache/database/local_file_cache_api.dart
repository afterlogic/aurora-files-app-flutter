import 'package:domain/model/local_file.dart';
import 'package:domain/model/storage.dart';

abstract class LocalFileCacheApi  {
  Future<List<LocalFile>> getAll();

  Future<int> add(LocalFile file);

  Future<int> deleteFiles(List<LocalFile> files);

  Future<List<Storage>> getStorages();

  Future<List<LocalFile>> getFilesAtPath(String path);

  Future<List<LocalFile>> searchFiles(String path, String searchPattern);
}
