import 'package:aurorafiles/assets/asset.dart';
import 'package:aurorafiles/models/share_principal.dart';

class ContactGroup extends SharePrincipal {
  final int id;
  final String name;
  final String? emails;
  final bool? isGroup;
  final bool? isAll;

  ContactGroup({
    required this.id,
    required this.name,
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
  String getId() => '$id';

  @override
  String getLabel() => name;

  @override
  String? getSvgIconAsset() =>
      isAll == true ? Asset.svg.iconTeam16 : Asset.svg.iconGroup16;

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
