// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'quota.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Quota _$QuotaFromJson(Map<String, dynamic> json) {
  return Quota(
    json['Limit'] as int,
    json['Used'] as int,
  );
}

Map<String, dynamic> _$QuotaToJson(Quota instance) => <String, dynamic>{
      'Limit': instance.limit,
      'Used': instance.used,
    };
