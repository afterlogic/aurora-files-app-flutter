import 'package:domain/model/bd/local_file.dart';
import 'package:domain/model/bd/storage.dart';

abstract class LocalFileCacheApi {
  Future<List<LocalFile>> getAll();

  Future set(LocalFile file);

  Future deleteAll(List<int> ids);

  Future<List<Storage>> getStorages();

  Future<List<LocalFile>> getFilesAtPath(
    String storage,
    String path,
  );

  Future<List<LocalFile>> searchFiles(
    String storage,
    String path,
    String searchPattern,
  );
}
