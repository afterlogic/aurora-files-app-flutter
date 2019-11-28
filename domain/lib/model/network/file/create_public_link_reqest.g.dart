// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_public_link_reqest.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PublicLinkRequest _$PublicLinkRequestFromJson(Map<String, dynamic> json) {
  return PublicLinkRequest(
    json['userId'] as int,
    json['type'] as String,
    json['path'] as String,
    json['name'] as String,
    json['size'] as int,
    json['isFolder'] as bool,
  );
}

Map<String, dynamic> _$PublicLinkRequestToJson(PublicLinkRequest instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'type': instance.type,
      'path': instance.path,
      'name': instance.name,
      'size': instance.size,
      'isFolder': instance.isFolder,
    };
