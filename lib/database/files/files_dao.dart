import 'dart:io';

import 'package:aurorafiles/database/app_database.dart';
import 'package:aurorafiles/database/files/files_table.dart';
import 'package:aurorafiles/models/storage.dart';
import 'package:aurorafiles/modules/app_store.dart';
import 'package:aurorafiles/utils/offline_utils.dart';
import 'package:aurorafiles/utils/permissions.dart';
import 'package:moor_flutter/moor_flutter.dart';

part 'files_dao.g.dart';

// the _FilesDaoMixin will be created by moor. It contains all the necessary
// fields for the tables. The <AppDatabase> type annotation is the database class
// that should use this dao.
@UseDao(tables: [Files])
class FilesDao extends DatabaseAccessor<AppDatabase> with _$FilesDaoMixin {
  // this constructor is required so that the main database can create an instance
  // of this object.
  FilesDao(AppDatabase db) : super(db);

  String get userEmail => AppStore.authState.userEmail ?? '';

  String get hostName => AppStore.authState.hostName ?? '';

  String get storageType => StorageTypeHelper.toName(
        AppStore.filesState.selectedStorage.type,
      );

  Future<List<LocalFile>> getAllFiles() {
    return select(files).get();
  }

  Future<List<Storage>> getStorages() async {
    final offlineFiles = await select(files).get();
    final Set<String> storageNames = {};
    offlineFiles.forEach((file) => storageNames.add(file.type));

    return storageNames.map((name) => getStorageFromName(name)).toList();
  }

  Future<List<LocalFile>> getFilesAtPath(String nullablePath) async {
    final path = nullablePath;
    final offlineFiles = await (select(files)
          ..where((file) => file.type.equals(storageType)))
        .get();
    // get files from subfolders to recreate folders structure
    final childFiles =
        offlineFiles.where((file) => file.path.contains(path)).toList();
    final Set<String> folderNames = {};
    childFiles.forEach((file) {
      try {
        String trimmedPath =
            file.path.substring(path.isEmpty ? 1 : path.length);
        if (trimmedPath.startsWith("/")) trimmedPath = trimmedPath.substring(1);
        final name = trimmedPath.split("/")[0];
        if (name.isNotEmpty) folderNames.add(name);
      } catch (err) {
        print(err);
      }
    });
    Set<LocalFile> filesAtPath = {};
    folderNames.forEach((name) {
      filesAtPath.add(getFolderFromName(name, path));
    });
    filesAtPath = <LocalFile>{
      ...filesAtPath,
      ...offlineFiles.where((file) => file.path == path).toList()
    };
    return filesAtPath.toList();
  }

  Future<List<LocalFile>> searchFiles(
      String? nullablePath, String searchPattern) async {
    final path = nullablePath == null ? "" : nullablePath;
    final query = searchPattern.toLowerCase().trim();
    final offlineFiles = await (select(files)
          ..where((file) => file.type.equals(storageType)))
        .get();
    // get files from subfolders to recreate folders structure
    final childFiles =
        offlineFiles.where((file) => file.path.contains(path)).toList();
    final Set<Map<String, String>> folders = {};
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
    } catch (err) {
      print(err);
    }
    Set<LocalFile> filesAtPath = {};
    folders.forEach((folder) {
      filesAtPath
          .add(getFolderFromName(folder["name"] ?? '', folder["path"] ?? ''));
    });
    filesAtPath = <LocalFile>{
      ...filesAtPath,
      ...childFiles
          .where((file) => file.name.toLowerCase().contains(query))
          .toList()
    };
    return filesAtPath.toList();
  }

  Future<int> addFile(FilesCompanion file) async {
    return into(files).insert(file);
  }

  Future<int> deleteFiles(List<LocalFile> filesToDelete) async {
    if (!Platform.isIOS) await getStoragePermissions();

    final List<int> ids = filesToDelete.map((file) => file.localId).toList();
    filesToDelete.forEach((file) {
      final fileToDelete = File(file.localPath);
      if (fileToDelete.existsSync()) fileToDelete.delete();
    });
    return (delete(files)..where((file) => file.localId.isIn(ids))).go();
  }

  Future<int> updateFile(FilesCompanion file) {
    return into(files).insert(file, mode: InsertMode.insertOrReplace);
  }

  Future<List<LocalFile>> getFilesForStorage(String displayName) async {
    return (select(files)..where((file) => file.type.equals(storageType)))
        .get();
  }

  Future<int> deleteAllFiles() async {
    final files = await getAllFiles();
    return deleteFiles(files);
  }
}
