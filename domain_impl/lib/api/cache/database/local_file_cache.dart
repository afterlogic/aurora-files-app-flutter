import 'package:dao_wrapped/dao/dao_mixin.dart';
import 'package:domain/api/cache/database/local_file_cache_api.dart';
import 'package:domain/api/cache/storage/user_storage_api.dart';
import 'package:domain/model/bd/local_file.dart';
import 'package:domain/model/bd/storage.dart';
import 'package:domain_impl/api/cache/database/local_file_table.dart';
import 'package:sqflite/sqlite_api.dart';

class LocalFileCache with DaoMixin<LocalFile> implements LocalFileCacheApi {
  @override
  final LocalFileTable databaseGateway;

  final UserStorageApi _userStorageApi;

  LocalFileCache(Database database, this._userStorageApi)
      : databaseGateway = LocalFileTable(database);

  @override
  Future<List<LocalFile>> getAll() async {
    return getByField("owner", _userStorageApi.userEmail.get());
  }

  @override
  Future<List<Storage>> getStorages() async {
    final storageNames = new Set<String>();
    (await getAll()).forEach((file) => storageNames.add(file.type));
    return storageNames.map((name) => Storage.fromName(name)).toList();
  }

  @override
  Future<List<LocalFile>> getFilesAtPath(String storage, String path) async {
    final _path = path ?? "";
    final userEmail = _userStorageApi.userEmail.get();
    final offlineFiles =
        await getByFields(["owner", "type"], [userEmail, storage]);
    final childFiles =
        offlineFiles.where((file) => file.path.contains(_path)).toList();
    final folderNames = new Set<String>();
    childFiles.forEach((file) {
      try {
        String trimmedPath =
            file.path.substring(_path.isEmpty ? 1 : _path.length);
        if (trimmedPath.startsWith("/")) trimmedPath = trimmedPath.substring(1);
        final name = trimmedPath.split("/")[0];
        if (name.isNotEmpty) folderNames.add(name);
      } catch (err) {}
    });
    Set<LocalFile> filesAtPath = new Set();
    folderNames.forEach((name) {
      filesAtPath.add(LocalFile.getFolderFromName(
        name,
        _path,
        storage,
        userEmail,
      ));
    });
    filesAtPath.addAll(offlineFiles.where((file) => file.path == _path));
    return filesAtPath.toList();
  }

  @override
  Future<List<LocalFile>> searchFiles(
    String storage,
    String path,
    String searchPattern,
  ) async {
    final _path = path ?? "";
    final userEmail = _userStorageApi.userEmail.get();
    final query = searchPattern.toLowerCase().trim();
    final offlineFiles =
        await getByFields(["owner", "type"], [userEmail, storage]);
    // get files from subfolders to recreate folders structure
    final childFiles =
        offlineFiles.where((file) => file.path.contains(_path)).toList();
    final folders = new Set<Map<String, String>>();
    try {
      childFiles.forEach((file) {
        String trimmedPath = file.path.substring(path.length);
        if (trimmedPath.isNotEmpty &&
            trimmedPath.toLowerCase().contains(query)) {
          final splitFolderPath = trimmedPath.split("/");
          final matchingFolder = splitFolderPath.lastWhere((folderName) {
            return folderName.toLowerCase().contains(query);
          });
          final splitFilePath = file.path.split("/");
          final index = splitFilePath.lastIndexOf(matchingFolder);
          final folderPath = splitFilePath.sublist(0, index).join("/");
          if (!folders.contains({"name": matchingFolder, "path": folderPath})) {
            folders.add({"name": matchingFolder, "path": folderPath});
          }
        }
      });
    } catch (err) {}
    Set<LocalFile> filesAtPath = new Set();
    folders.forEach((folder) {
      filesAtPath.add(LocalFile.getFolderFromName(
        folder["name"],
        folder["path"],
        storage,
        userEmail,
      ));
    });
    filesAtPath.addAll(
        childFiles.where((file) => file.name.toLowerCase().contains(query)));

    return filesAtPath.toList();
  }

  @override
  Future deleteAll(List<dynamic> ids) {
    //  todo delete local file
    // if (!Platform.isIOS) await getStoragePermissions();
    //
    // final List<int> ids = filesToDelete.map((file) => file.localId).toList();
    // filesToDelete.forEach((file) {
    //   final fileToDelete = new File(file.localPath);
    //   if (fileToDelete.existsSync()) fileToDelete.delete();
    // });
    return super.deleteAll(ids);
  }

  //todo add to lib
  Future<List<LocalFile>> getByFields(
      List<String> fields, List<dynamic> value) async {
    var where = "";
    for (String field in fields) {
      if (where.isNotEmpty) {
        where += ",";
      }
      where += "$field = ?";
    }

    var result = await databaseGateway.db
        .query(databaseGateway.table, where: where, whereArgs: value);
    return result.map((json) => databaseGateway.fromMap(json)).toList();
  }
}
