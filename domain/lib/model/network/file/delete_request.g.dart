// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'delete_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DeleteRequest _$DeleteRequestFromJson(Map<String, dynamic> json) {
  return DeleteRequest(
    json['type'] as String,
    json['path'] as String,
    (json['items'] as List)
        ?.map((e) =>
            e == null ? null : FileToDelete.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  );
}

Map<String, dynamic> _$DeleteRequestToJson(DeleteRequest instance) =>
    <String, dynamic>{
      'type': instance.type,
      'path': instance.path,
      'items': instance.items,
    };
