import 'package:aurorafiles/models/share_principal.dart';
import 'package:flutter/foundation.dart';

class ContactGroup extends SharePrincipal {
  final int id;
  final String name;
  final String emails;
  final bool isGroup;
  final bool isAll;

  ContactGroup({
    @required this.id,
    @required this.name,
    this.emails,
    this.isGroup,
    this.isAll,
  });

  static ContactGroup fromJson(Map<String, dynamic> map) {
    return ContactGroup(
      id: map["Id"],
      name: map["Name"],
      emails: map["Emails"],
      isGroup: map["IsGroup"],
      isAll: map["IsAll"],
    );
  }

  @override
  String getId() => '${this.id}';

  @override
  String getLabel() => '\u25FE ${this.name}';

  @override
  Map<String, dynamic> toMap() {
    return {
      "PublicId": name,
      "IsAll": isAll,
      "IsGroup": isGroup,
      "GroupId": id,
    };
  }
}
