import 'package:aurorafiles/database/app_database.dart';
import 'package:aurorafiles/models/storage.dart';
import 'package:aurorafiles/modules/app_store.dart';
import 'package:moor_flutter/moor_flutter.dart';

Storage getStorageFromName(String name) {
  return new Storage(
    type: name,
    displayName: name[0].toUpperCase() + name.substring(1),
    isExternal: false,
  );
}

FilesCompanion getCompanionFromLocalFile(LocalFile file, String pathToFile) {
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

LocalFile getFolderFromName(String name, String path) {
  String storageType = AppStore.filesState.selectedStorage.type;
  String userEmail = AppStore.authState.userEmail;
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