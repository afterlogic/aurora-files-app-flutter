import 'package:aurorafiles/models/contact_group.dart';
import 'package:aurorafiles/models/recipient.dart';
import 'package:aurorafiles/models/share_access_right.dart';
import 'package:aurorafiles/models/share_principal.dart';
import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';

class ShareAccessEntry {
  final SharePrincipal principal;
  final ShareAccessRight access;
  final String id;

  ShareAccessEntry({
    @required this.principal,
    @required this.access,
    String id,
  }) : id = id ?? Uuid().v4();

  static ShareAccessEntry fromShareJson(Map<String, dynamic> map) {
    Recipient recipient;
    ContactGroup group;
    if (map["IsGroup"] != null) {
      group = ContactGroup(
        id: map["GroupId"],
        name: map["PublicId"],
        isGroup: map["IsGroup"],
        isAll: map["IsAll"],
      );
    } else {
      recipient = Recipient(
        email: map["PublicId"],
      );
    }
    final access = ShareAccessRightHelper.fromCode(map["Access"]);
    if ((recipient == null && group == null) || access == null) {
      return null;
    } else {
      return ShareAccessEntry(
        principal: recipient ?? group,
        access: access,
      );
    }
  }

  Map<String, dynamic> toMap() {
    final map = principal.toMap();
    map["Access"] = ShareAccessRightHelper.toCode(access);
    return map;
  }

  ShareAccessEntry copyWith({ShareAccessRight access}) {
    return ShareAccessEntry(
      principal: this.principal,
      access: access ?? this.access,
      id: this.id,
    );
  }
}
