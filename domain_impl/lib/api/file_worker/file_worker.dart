import 'dart:io';

import 'package:domain/api/cache/database/local_file_cache_api.dart';
import 'package:domain/api/file_worker/file_cache_worker_api.dart';
import 'package:domain/model/bd/local_file.dart';

class FileWorker extends FileWorkerApi {
  final LocalFileCacheApi _fileCacheApi;

  FileWorker(this._fileCacheApi);

  @override
  Future deleteAll(List<LocalFile> list) async {
    //todo
    //if (!Platform.isIOS) await getStoragePermissions();

    final List<int> ids = list.map((file) => file.localId).toList();
    list.forEach((file) {
      final fileToDelete = new File(file.localPath);
      if (fileToDelete.existsSync()) fileToDelete.delete();
    });
    return _fileCacheApi.deleteAll(ids);
  }

  @override
  deleteFiles(List<LocalFile> filesToDeleteLocally) {
    // TODO: implement deleteFiles
    return null;
  }

  @override
  getFilesAtPath(String pagePath) {
    // TODO: implement getFilesAtPath
    return null;
  }

  @override
  getStorages() {
    // TODO: implement getStorages
    return null;
  }

  @override
  searchFiles(String pagePath, String searchPattern) {
    // TODO: implement searchFiles
    return null;
  }
}
