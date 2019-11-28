// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'quota.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Quota _$QuotaFromJson(Map<String, dynamic> json) {
  return Quota(
    json['limit'] as int,
    json['used'] as int,
  );
}

Map<String, dynamic> _$QuotaToJson(Quota instance) => <String, dynamic>{
      'limit': instance.limit,
      'used': instance.used,
    };
