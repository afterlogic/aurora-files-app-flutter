import 'dart:io';

import 'package:aurorafiles/models/storage.dart';
import 'package:aurorafiles/modules/app_store.dart';
import 'package:aurorafiles/utils/api_utils.dart';
import 'package:aurorafiles/utils/custom_exception.dart';
import 'package:aurorafiles/utils/permissions.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:moor_flutter/moor_flutter.dart';
import 'package:path_provider/path_provider.dart';

import '../app_database.dart';
import 'files_table.dart';

part 'files_dao.g.dart';

// the _FilesDaoMixin will be created by moor. It contains all the necessary
// fields for the tables. The <AppDatabase> type annotation is the database class
// that should use this dao.
@UseDao(tables: [Files])
class FilesDao extends DatabaseAccessor<AppDatabase> with _$FilesDaoMixin {
  // this constructor is required so that the main database can create an instance
  // of this object.
  FilesDao(AppDatabase db) : super(db);

  String get userEmail => AppStore.authState.userEmail;

  String get hostName => AppStore.authState.hostName;

  String get storageType => AppStore.filesState.selectedStorage.type;

  Future<List<LocalFile>> getAllFiles() {
    return (select(files)..where((file) => file.owner.equals(userEmail))).get();
  }

  Future<List<Storage>> getStorages() async {
    final offlineFiles = await (select(files)
          ..where((file) => file.owner.equals(userEmail)))
        .get();
    final storageNames = new Set<String>();
    offlineFiles.forEach((file) => storageNames.add(file.type));

    return storageNames.map((name) => _getStorageFromName(name)).toList();
  }

  Future<List<LocalFile>> getFilesAtPath(String nullablePath) async {
    final path = nullablePath == null ? "" : nullablePath;
    final offlineFiles = await (select(files)
          ..where((file) => file.owner.equals(userEmail))
          ..where((file) => file.type.equals(storageType)))
        .get();
    // get files from subfolders to recreate filesStructure
    final childFiles =
        offlineFiles.where((file) => file.path.contains(path)).toList();
    final folderNames = new Set<String>();
    childFiles.forEach((file) {
      try {
        String trimmedPath =
            file.path.substring(path.isEmpty ? 1 : path.length);
        if (trimmedPath.startsWith("/")) trimmedPath = trimmedPath.substring(1);
        final name = trimmedPath.split("/")[0];
        if (name.isNotEmpty) folderNames.add(name);
      } catch (err) {}
    });
    Set<LocalFile> filesAtPath = new Set();
    folderNames.forEach((name) {
      filesAtPath.add(_getFolderFromName(name, path));
    });
    filesAtPath = [
      ...filesAtPath,
      ...offlineFiles.where((file) => file.path == path).toList()
    ].toSet();
    return filesAtPath.toList();
  }

  Future<int> addFile(LocalFile file) async {
    if (!Platform.isIOS) await getStoragePermissions();
    Directory dir = await getApplicationDocumentsDirectory();
    if (!dir.existsSync()) dir = await getApplicationDocumentsDirectory();
    if (!dir.existsSync()) {
      throw CustomException("Could not resolve save directory");
    }

    String fileId = file.path.replaceAll("/", ".");
    fileId += "%FILENAME:${file.name}";

    await FlutterDownloader.enqueue(
      url: hostName + file.downloadUrl,
      savedDir: dir.path,
      fileName: fileId,
      headers: getHeader(),
      showNotification: false,
      openFileFromNotification: false,
    );
    return into(files)
        .insert(_getCompanionFromLocalFile(file, "${dir.path}/$fileId"));
  }

  Future<int> deleteFiles(List<LocalFile> filesToDelete) async {
    final List<int> ids = filesToDelete.map((file) => file.localId).toList();
    if (!Platform.isIOS) await getStoragePermissions();
    filesToDelete.forEach((file) {
      final fileToDelete = new File(file.localPath);
      if (fileToDelete.existsSync()) fileToDelete.delete();
    });
    return (delete(files)..where((file) => isIn(file.localId, ids))).go();
  }

  Storage _getStorageFromName(String name) {
    return new Storage(
      type: name,
      displayName: name[0].toUpperCase() + name.substring(1),
      isExternal: false,
    );
  }

  FilesCompanion _getCompanionFromLocalFile(LocalFile file, String pathToFile) {
    return new FilesCompanion(
      id: Value(file.id),
      type: Value(file.type),
      path: Value(file.path),
      fullPath: Value(file.fullPath),
      localPath: Value(pathToFile),
      name: Value(file.name),
      size: Value(file.size),
      isFolder: Value(file.isFolder),
      isOpenable: Value(file.isOpenable),
      isLink: Value(file.isLink),
      linkType: Value(file.linkType),
      linkUrl: Value(file.linkUrl),
      lastModified: Value(file.lastModified),
      contentType: Value(file.contentType),
      oEmbedHtml: Value(file.oEmbedHtml),
      published: Value(file.published),
      owner: Value(file.owner),
      content: Value(file.content),
      viewUrl: Value(file.viewUrl),
      downloadUrl: Value(file.downloadUrl),
      thumbnailUrl: Value(file.thumbnailUrl),
      hash: Value(file.hash),
      extendedProps: Value(file.extendedProps),
      isExternal: Value(file.isExternal),
      initVector: Value(file.initVector),
    );
  }

  LocalFile _getFolderFromName(String name, String path) {
    return new LocalFile(
      localId: null,
      id: name,
      type: storageType,
      path: path,
      fullPath: path.isEmpty ? "/" + name : "$path/$name",
      localPath: null,
      name: name,
      size: 0,
      isFolder: true,
      isOpenable: true,
      isLink: false,
      linkType: "",
      linkUrl: "",
      lastModified: 0,
      contentType: "",
      oEmbedHtml: "",
      published: false,
      owner: userEmail,
      content: "",
      viewUrl: null,
      downloadUrl: null,
      hash: null,
      extendedProps: "[]",
      isExternal: false,
    );
  }
}
