import 'package:json_annotation/json_annotation.dart';

part 'quota.g.dart';

@JsonSerializable()
class Quota {
  final int limit;
  final int used;

  Quota(this.limit, this.used);

  factory Quota.fromJson(Map<String, dynamic> json) => _$QuotaFromJson(json);

  get progress => used / limit;

  Map<String, dynamic> toJson() => _$QuotaToJson(this);
}
