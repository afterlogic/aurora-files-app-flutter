import 'dart:convert';

import 'package:aurorafiles/database/app_database.dart';
import 'package:aurorafiles/models/api_body.dart';
import 'package:aurorafiles/modules/app_store.dart';
import 'package:aurorafiles/utils/api_utils.dart';

class PgpKeyApi {
  Future<void> addKeyToContacts(List<LocalPgpKey> keys) async {
    final body = ApiBody(
      module: "OpenPgpWebclient",
      method: "AddPublicKeysToContacts",
      parameters: json.encode({
        "UserId": AppStore.authState.userId,
        "Keys": keys
            .map(
              (item) => {
                "Email": item.email,
                "Name": item.name,
                "Key": item.key,
              },
            )
            .toList(),
      }),
    );

    final result = await sendRequest(body);
    return result["Result"] as bool;
  }

  Future<List<LocalPgpKey>> getKeyFromContacts() async {
    final body = ApiBody(
      module: "OpenPgpWebclient",
      method: "GetPublicKeysFromContacts",
    );

    final result = await sendRequest(body);
    try {
      if (result["Result"] is List) {
        return (result["Result"] as List).map<LocalPgpKey>((item) {
          return LocalPgpKey(
            email: item["Email"],
            key: item["PublicPgpKey"],
            isPrivate: false,
            name: "",
            id: null,
          );
        }).toList();
      } else {
        return [];
      }
    } catch (e) {
      return [];
    }
  }

  Future deleteContactKey(String email) async {
    final body = ApiBody(
      module: "OpenPgpWebclient",
      method: "RemovePublicKeyFromContact",
      parameters: jsonEncode({"Email": email}),
    );

    final result = await sendRequest(body);
    return result["Result"] as bool;
  }
}
