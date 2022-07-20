import 'dart:convert';

import 'package:aurorafiles/database/app_database.dart';
import 'package:aurorafiles/models/account.dart';
import 'package:aurorafiles/models/api_body.dart';
import 'package:aurorafiles/models/folder.dart';
import 'package:aurorafiles/models/recipient.dart';
import 'package:aurorafiles/modules/app_store.dart';
import 'package:aurorafiles/modules/files/repository/share_access_entry.dart';
import 'package:aurorafiles/modules/files/repository/share_access_right.dart';
import 'package:aurorafiles/utils/api_utils.dart';
import 'package:aurorafiles/utils/custom_exception.dart';

class MailApi {
  Future<List<Recipient>> getRecipient() async {
    final parameters = {
      "Search": "",
      "Storage": "all",
      "SortField": 3,
      "SortOrder": 1,
      "WithGroups": false,
      "WithoutTeamContactsDuplicates": true
    };
    final body = new ApiBody(
      module: "Contacts",
      method: "GetContacts",
      parameters: json.encode(parameters),
    );

    final res = (await sendRequest(body)) as Map;

    if (res.containsKey("Result")) {
      return (res["Result"]["List"] as List)
          .map((item) => Recipient.fromJson(item))
          .toList();
    } else {
      throw CustomException(getErrMsg(res));
    }
  }

  Future<List<Account>> getAccounts() async {
    final parameters = {"UserId": AppStore.authState.userId};
    final body = new ApiBody(
      module: "Mail",
      method: "GetAccounts",
      parameters: json.encode(parameters),
    );

    final res = (await sendRequest(body)) as Map;

    if (res.containsKey("Result")) {
      return (res["Result"] as List)
          .map((item) => Account.fromJson(item))
          .toList();
    } else {
      throw CustomException(getErrMsg(res));
    }
  }

  Future<FoldersResult> getFolder(int accountID) async {
    final parameters = {
      "AccountID": accountID,
    };
    final body = new ApiBody(
      module: "Mail",
      method: "GetFolders",
      parameters: json.encode(parameters),
    );

    final res = (await sendRequest(body)) as Map;

    if (res.containsKey("Result")) {
      return FoldersResult.fromJson(res["Result"]);
    } else {
      throw CustomException(getErrMsg(res));
    }
  }

  Future<bool> sendMail(int accountID, String folder, String subject,
      String text, String to) async {
    final parameters = {
      "AccountID": accountID,
      "IsHtml": false,
      "SentFolder": folder,
      "Subject": subject,
      "Text": text,
      "To": to,
      "IdentityId": 677,
      "Method": "SendMessage"
    };
    final body = new ApiBody(
      module: "Mail",
      method: "SendMessage",
      parameters: json.encode(parameters),
    );

    final res = (await sendRequest(body)) as Map;

    if (res.containsKey("Result")) {
      return res["Result"];
    } else {
      throw CustomException(getErrMsg(res));
    }
  }

  Future<List<Recipient>> searchContact(String pattern) async {
    final parameters = {
      "Search": pattern,
      "Storage": "team",
      "SortField": 3,
      "SortOrder": 1,
      "WithGroups": false,
      "WithoutTeamContactsDuplicates": true,
    };
    final body = new ApiBody(
      module: "Contacts",
      method: "GetContactSuggestions",
      parameters: json.encode(parameters),
    );

    final res = (await sendRequest(body)) as Map;

    if (res.containsKey("Result")) {
      return (res["Result"]["List"] as List)
          .map((item) => Recipient.fromJson(item))
          .toList();
    } else {
      throw CustomException(getErrMsg(res));
    }
  }

  Future<List<Map>> shareFileToTeammate(
    LocalFile localFile,
    List<ShareAccessEntry> shares,
  ) async {
    final shareList = <Map>[];
    for (var share in shares) {
      shareList.add({
        "PublicId": share.recipient.email,
        "Access": ShareAccessRightHelper.toCode(share.right),
      });
    }
    final parameters = {
      "Storage": localFile.type,
      "Path": localFile.path,
      "Id": localFile.id,
      "Shares": shareList,
      "IsDir": localFile.isFolder,
    };
    final body = new ApiBody(
      module: "SharedFiles",
      method: "UpdateShare",
      parameters: json.encode(parameters),
    );

    final res = (await sendRequest(body)) as Map;

    if (res["Result"] == true) {
      return shareList;
    } else {
      throw CustomException(getErrMsg(res));
    }
  }

  Future<void> shareFileToContact(
    LocalFile localFile,
    Set<String> canEdit,
    Set<String> canSee,
  ) async {
    final contact = <Map>[];
    for (var value in canSee) {
      contact.add({"PublicId": value, "Access": 2});
    }
    for (var value in canEdit) {
      contact.add({"PublicId": value, "Access": 1});
    }
    final parameters = {
      "Storage": localFile.type,
      "Path": localFile.path,
      "Id": localFile.id,
      "Shares": contact,
      "IsDir": false
    };
    final body = new ApiBody(
      module: "SharedFiles",
      method: "UpdateShare",
      parameters: json.encode(parameters),
    );

    final res = (await sendRequest(body)) as Map;

    if (res["Result"] == true) {
      return;
    } else {
      throw CustomException(getErrMsg(res));
    }
  }
}
