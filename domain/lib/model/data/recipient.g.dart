// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recipient.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Recipient _$RecipientFromJson(Map<String, dynamic> json) {
  return Recipient(
    json['email'] as String,
    json['idUser'] as int,
    json['fullName'] as String,
  );
}

Map<String, dynamic> _$RecipientToJson(Recipient instance) => <String, dynamic>{
      'email': instance.email,
      'idUser': instance.idUser,
      'fullName': instance.fullName,
    };
