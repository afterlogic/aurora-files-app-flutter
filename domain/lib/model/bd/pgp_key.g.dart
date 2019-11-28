// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pgp_key.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PgpKey _$PgpKeyFromJson(Map<String, dynamic> json) {
  return PgpKey()
    ..id = json['id'] as int
    ..email = json['email'] as String
    ..key = json['key'] as String
    ..isPrivate = json['isPrivate'] as bool;
}

Map<String, dynamic> _$PgpKeyToJson(PgpKey instance) => <String, dynamic>{
      'id': instance.id,
      'email': instance.email,
      'key': instance.key,
      'isPrivate': instance.isPrivate,
    };
