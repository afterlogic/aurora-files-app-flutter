import 'dart:convert';

import 'package:aurorafiles/database/app_database.dart';
import 'package:aurorafiles/models/api_body.dart';
import 'package:aurorafiles/store/app_state.dart';
import 'package:http/http.dart' as http;

Map<String, String> getHeader(String authToken) {
  return {'Authorization': 'Bearer $authToken'};
}

Future sendRequest(ApiBody body) async {
  final store = SingletonStore.instance;
  final rawResponse = await http.post(store.apiUrl,
      headers: getHeader(store.authToken), body: body.toMap());

  return json.decode(rawResponse.body);
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
