import 'dart:convert';

import 'package:aurorafiles/database/app_database.dart';
import 'package:aurorafiles/models/api_body.dart';
import 'package:aurorafiles/models/processing_file.dart';
import 'package:aurorafiles/modules/app_store.dart';
import 'package:http/http.dart' as http;
import 'package:uuid/uuid.dart';

import 'file_utils.dart';

Map<String, String> getHeader() {
  return {'Authorization': 'Bearer ${AppStore.authState.authToken}'};
}

Future sendRequest(ApiBody body) async {
  final authState = AppStore.authState;
  final rawResponse = await http.post(authState.apiUrl,
      headers: getHeader(), body: body.toMap());

  return json.decode(rawResponse.body);
}

LocalFile getFakeLocalFileForUploadProgress(
    ProcessingFile processingFile, String path) {
  final fileName =
      FileUtils.getFileNameFromPath(processingFile.fileOnDevice.path);
  return new LocalFile(
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
    case 101:
      return "Invalid token";
    case 102:
      return "Invalid email/password";
    case 103:
      return "Invalid input parameter";
    case 104:
      return "DataBase error";
    case 105:
      return "License problem";
    case 106:
      return "Demo account";
    case 107:
      return "Captcha error";
    case 108:
      return "Access denied";
    case 109:
      return "Unknown email";
    case 110:
      return "User is not allowed";
    case 111:
      return "Such user already exists";
    case 112:
      return "System is not configured";
    case 113:
      return "Module not found";
    case 114:
      return "Method not found";
    case 115:
      return "License limit";
    case 501:
      return "Cannot save settings";
    case 502:
      return "Cannot change password";
    case 503:
      return "Account's old password is not correct";
    case 601:
      return "Cannot create contact";
    case 602:
      return "Cannot create group";
    case 603:
      return "Cannot update contact";
    case 604:
      return "Cannot update group";
    case 605:
      return "Contact data has been modified by another application";
    case 607:
      return "Cannot get contact";
    case 701:
      return "Cannot create account";
    case 704:
      return "Such account already exists";
    case 710:
      return "Rest other error";
    case 711:
      return "Rest api disabled";
    case 712:
      return "Rest unknown method";
    case 713:
      return "Rest invalid parameters";
    case 714:
      return "Rest invalid credentials";
    case 715:
      return "Rest invalid token";
    case 716:
      return "Rest token expired";
    case 717:
      return "Rest account find failed";
    case 719:
      return "Rest tenant find failed";
    case 801:
      return "Calendars not allowed";
    case 802:
      return "Files not allowed";
    case 803:
      return "Contacts not allowed";
    case 804:
      return "Helpdesk user already exists";
    case 805:
      return "Helpdesk system user already exists";
    case 806:
      return "Cannot create helpdesk user";
    case 807:
      return "Helpdesk unknown user";
    case 808:
      return "Helpdesk unactivated user";
    case 810:
      return "Voice not allowed";
    case 811:
      return "Incorrect file extension";
    case 812:
      return "You have reached your cloud storage space limit. Can't upload file.";
    case 813:
      return "Such file already exists";
    case 814:
      return "File not found";
    case 815:
      return "Cannot upload file limit";
    case 901:
      return "Mail server error";
    case 999:
      return "Unknown error";
    default:
      return code.toString();
  }
}

LocalFile getFileObjFromResponse(Map<String, dynamic> rawFile) {
  return LocalFile(
    localId: null,
    id: rawFile["Id"],
    guid: rawFile["ExtendedProps"] is Map
        ? rawFile["ExtendedProps"]["GUID"]
        : null,
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
