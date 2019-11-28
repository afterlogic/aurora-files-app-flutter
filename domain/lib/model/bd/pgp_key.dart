import 'package:json_annotation/json_annotation.dart';

part 'pgp_key.g.dart';

@JsonSerializable()
class PgpKey {
  int id;
  String email;
  String key;
  bool isPrivate;

  PgpKey();

  PgpKey.fill({this.email, this.key, this.isPrivate});

  factory PgpKey.fromJson(Map<String, dynamic> json) => _$PgpKeyFromJson(json);

  Map<String, dynamic> toJson() => _$PgpKeyToJson(this);
}
