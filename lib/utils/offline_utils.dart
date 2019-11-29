import 'package:aurorafiles/modules/app_store.dart';
import 'package:domain/model/bd/local_file.dart';

LocalFile getCompanionFromLocalFile(LocalFile file, String pathToFile) {
  return new LocalFile.fill(
    id: file.id,
    guid: file.guid,
    type: file.type,
    path: file.path,
    fullPath: file.fullPath,
    localPath: pathToFile,
    name: file.name,
    size: file.size,
    isFolder: file.isFolder,
    isOpenable: file.isOpenable,
    isLink: file.isLink,
    linkType: file.linkType,
    linkUrl: file.linkUrl,
    lastModified: file.lastModified,
    contentType: file.contentType,
    oEmbedHtml: file.oEmbedHtml,
    published: file.published,
    owner: file.owner,
    content: file.content,
    viewUrl: file.viewUrl,
    downloadUrl: file.downloadUrl,
    thumbnailUrl: file.thumbnailUrl,
    hash: file.hash,
    extendedProps: file.extendedProps,
    isExternal: file.isExternal,
    initVector: file.initVector,
  );
}

LocalFile getFolderFromName(String name, String path) {
  String storageType = AppStore.filesState.selectedStorage.type;
  String userEmail = AppStore.authState.userEmail;
  return new LocalFile.fill(
    localId: null,
    id: name,
    guid: null,
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
