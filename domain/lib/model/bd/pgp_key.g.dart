// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pgp_key.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PgpKey _$PgpKeyFromJson(Map<String, dynamic> json) {
  return PgpKey()
    ..email = json['email'] as String
    ..key = json['key'] as String
    ..isPrivate = json['isPrivate'] as bool;
}

Map<String, dynamic> _$PgpKeyToJson(PgpKey instance) => <String, dynamic>{
      'email': instance.email,
      'key': instance.key,
      'isPrivate': instance.isPrivate,
    };
