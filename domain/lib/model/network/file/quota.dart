import 'package:json_annotation/json_annotation.dart';
part 'quota.g.dart';
@JsonSerializable()
class Quota {
  @JsonKey(name: "Limit")
  final int limit;
  @JsonKey(name: "Used")
  final int used;

  Quota(this.limit, this.used);

  factory Quota.fromJson(Map<String, dynamic> json) => _$QuotaFromJson(json);

  Map<String, dynamic> toJson() => _$QuotaToJson(this);
}
