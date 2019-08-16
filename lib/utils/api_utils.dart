import 'package:aurorafiles/database/app_database.dart';

Map<String, String> getHeader(String authToken) {
  return {'Authorization': 'Bearer $authToken'};
}

String getErrMsg(dynamic err) {
  if (err["ErrorMessage"] is String) {
    return err["ErrorMessage"];
  } else if (err["ErrorCode"] is int) {
    return _getErrMsgFromCode(err["ErrorCode"]);
  } else {
    return "Unknown error";
  }
}

String _getErrMsgFromCode(int code) {
  switch (code) {
    case (102):
      return "Invalid email/password";
    default:
      return code.toString();
  }
}

File getFileObjFromResponse(Map<String, dynamic> rawFile) {
  return File(
    localId: null,
    id: rawFile["Id"],
    type: rawFile["Type"],
    path: rawFile["Path"],
    fullPath: rawFile["FullPath"],
    name: rawFile["Name"],
    size: rawFile["Size"],
    isFolder: rawFile["IsFolder"],
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
  );
}
