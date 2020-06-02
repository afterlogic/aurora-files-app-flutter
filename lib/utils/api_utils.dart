import 'dart:convert';

import 'package:aurorafiles/database/app_database.dart';
import 'package:aurorafiles/error/api_error_code.dart';
import 'package:aurorafiles/models/api_body.dart';
import 'package:aurorafiles/models/processing_file.dart';
import 'package:aurorafiles/modules/app_store.dart';
import 'package:http/http.dart' as http;
import 'package:uuid/uuid.dart';

import 'file_utils.dart';

Map<String, String> getHeader() {
  return {'Authorization': 'Bearer ${AppStore.authState.authToken}'};
}

Future sendRequest(ApiBody body, [Map<String, dynamic> addedBody]) async {
  final authState = AppStore.authState;
  final map = body.toMap();
  addedBody?.forEach((key, value) {
    map[key] = value;
  });
  final rawResponse =
      await http.post(authState.apiUrl, headers: getHeader(), body: map);
  if (rawResponse.statusCode != 200) {
    return {"ErrorCode": unknownError};
  }
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
    case invalidToken:
      return "Invalid token";
    case invalidEmailPassword:
      return "Invalid email/password";
    case invalidInputParameter:
      return "Invalid input parameter";
    case dataBaseError:
      return "DataBase error";
    case licenseProblem:
      return "License problem";
    case demoAccount:
      return "Demo account";
    case captchaError:
      return "Captcha error";
    case accessDenied:
      return "Access denied";
    case unknownEmail:
      return "Unknown email";
    case userisNotAllowed:
      return "User is not allowed";
    case suchUserAlreadyExists:
      return "Such user already exists";
    case systemIsNotConfigured:
      return "System is not configured";
    case moduleNotFound:
      return "Module not found";
    case methodNotFound:
      return "Method not found";
    case licenseLimit:
      return "License limit";
    case cannotSaveSettings:
      return "Cannot save settings";
    case cannotChangePassword:
      return "Cannot change password";
    case accountOldPasswordIsNotCorrect:
      return "Account's old password is not correct";
    case cannotCreateContact:
      return "Cannot create contact";
    case cannotCreateGroup:
      return "Cannot create group";
    case cannotUpdateContact:
      return "Cannot update contact";
    case cannotUpdateGroup:
      return "Cannot update group";
    case dataHasBeenModified:
      return "Contact data has been modified by another application";
    case cannotGetContact:
      return "Cannot get contact";
    case cannotCreateAccount:
      return "Cannot create account";
    case suchAccountAlreadyExists:
      return "Such account already exists";
    case restOtherError:
      return "Rest other error";
    case restApiDisabled:
      return "Rest api disabled";
    case restUnknownMethod:
      return "Rest unknown method";
    case restInvalidParameters:
      return "Rest invalid parameters";
    case restInvalidCredentials:
      return "Rest invalid credentials";
    case restInvalidToken:
      return "Rest invalid token";
    case restTokenExpired:
      return "Rest token expired";
    case restAccountFindFailed:
      return "Rest account find failed";
    case restTenantFindFailed:
      return "Rest tenant find failed";
    case calendarsNotAllowed:
      return "Calendars not allowed";
    case filesNotAllowed:
      return "Files not allowed";
    case contactsNotAllowed:
      return "Contacts not allowed";
    case helpdeskUserAlreadyExists:
      return "Helpdesk user already exists";
    case helpdeskSystemUserAlreadyExists:
      return "Helpdesk system user already exists";
    case cannotCreateJHelpdeskUser:
      return "Cannot create helpdesk user";
    case helpdeskUnknownUser:
      return "Helpdesk unknown user";
    case helpdeskUnactivatedUser:
      return "Helpdesk unactivated user";
    case voiceNotAllowed:
      return "Voice not allowed";
    case incorrectFileExtension:
      return "Incorrect file extension";
    case spaceLimit:
      return "You have reached your cloud storage space limit. Can't upload file.";
    case fileAlreadyExists:
      return "Such file already exists";
    case fileNotFound:
      return "File not found";
    case cannotUploadFileLimit:
      return "Cannot upload file limit";
    case mailServerError:
      return "Mail server error";
    case unknownError:
      return "Unknown error";
    default:
      return code.toString();
  }
}

LocalFile getFileObjFromResponse(Map<String, dynamic> rawFile) {
  final props =
      rawFile["ExtendedProps"] is Map ? rawFile["ExtendedProps"] as Map : null;
  var publicLink = props != null ? props["PublicLink"] : null;
  if (publicLink != null) {
    publicLink = AppStore.authState.hostName + "/" + publicLink;
  }
  final linkPassword = props != null ? props["PasswordForSharing"] : null;
  return LocalFile(
    localId: null,
    id: rawFile["Id"],
    guid: props != null ? props["GUID"] : Uuid().v4(),
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
    linkUrl: publicLink ?? rawFile["LinkUrl"],
    linkPassword: linkPassword,
    lastModified: rawFile["LastModified"],
    contentType: rawFile["ContentType"],
    oEmbedHtml: rawFile["OembedHtml"],
    published: publicLink != null || rawFile["Published"]==true,
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
    extendedProps: rawFile["ExtendedProps"] != null
        ? jsonEncode(rawFile["ExtendedProps"])
        : null,
    initVector: props != null ? props["InitializationVector"] : null,
    encryptedDecryptionKey: props != null ? props["ParanoidKey"] : null,
  );
}
