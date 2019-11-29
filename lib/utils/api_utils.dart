import 'package:aurorafiles/models/processing_file.dart';
import 'package:aurorafiles/modules/app_store.dart';
import 'package:domain/model/bd/local_file.dart';
import 'package:uuid/uuid.dart';

import 'file_utils.dart';

LocalFile getFakeLocalFileForUploadProgress(
    ProcessingFile processingFile, String path) {
  final fileName =
      FileUtils.getFileNameFromPath(processingFile.fileOnDevice.path);
  return new LocalFile.fill(
    localId: null,
    id: fileName,
    guid: processingFile.guid,
    type: null,
    path: path,
    fullPath: path + fileName,
    localPath: processingFile.fileOnDevice.path,
    name: fileName,
    size: processingFile.fileOnDevice.lengthSync(),
    isFolder: false,
    isOpenable: false,
    isLink: false,
    linkType: null,
    linkUrl: null,
    lastModified: DateTime.now().millisecondsSinceEpoch ~/ 1000,
    contentType: "",
    oEmbedHtml: null,
    published: false,
    owner: AppStore.authState.userEmail,
    content: null,
    viewUrl: null,
    downloadUrl: null,
    thumbnailUrl: null,
    hash: null,
    extendedProps: "fake",
    isExternal: false,
    initVector: null,
  );
}

LocalFile getFileObjFromResponse(Map<String, dynamic> rawFile) {
  return LocalFile.fill(
    localId: null,
    id: rawFile["Id"],
    guid: rawFile["ExtendedProps"] is Map
        ? rawFile["ExtendedProps"]["GUID"]
        : Uuid().v4(),
    type: rawFile["Type"],
    localPath: null,
    path: rawFile["Path"],
    fullPath: rawFile["FullPath"],
    name: rawFile["Name"],
    size: rawFile["Size"],
    isFolder: rawFile["IsFolder"],
    isOpenable:
        rawFile["Actions"] != null && rawFile["Actions"]["list"] != null,
    isLink: rawFile["IsLink"],
    linkType: rawFile["LinkType"],
    linkUrl: rawFile["LinkUrl"],
    lastModified: rawFile["LastModified"],
    contentType: rawFile["ContentType"],
    oEmbedHtml: rawFile["OembedHtml"],
    published: rawFile["Published"],
    owner: rawFile["Owner"],
    content: rawFile["Content"],
    isExternal: rawFile["IsExternal"],
    thumbnailUrl: rawFile["ThumbnailUrl"],
    downloadUrl: rawFile["Actions"]["download"] != null
        ? rawFile["Actions"]["download"]["url"]
        : null,
    viewUrl: rawFile["Actions"]["view"] != null
        ? rawFile["Actions"]["view"]["url"]
        : null,
    hash: rawFile["Hash"],
    extendedProps: rawFile["ExtendedProps"].toString(),
    initVector: rawFile["ExtendedProps"] is Map
        ? rawFile["ExtendedProps"]["InitializationVector"]
        : null,
  );
}
