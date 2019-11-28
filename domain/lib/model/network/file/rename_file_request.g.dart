// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'rename_file_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RenameFileRequest _$RenameFileRequestFromJson(Map<String, dynamic> json) {
  return RenameFileRequest(
    json['type'] as String,
    json['path'] as String,
    json['name'] as String,
    json['newName'] as String,
    json['isLink'] as bool,
    json['isFolder'] as bool,
  );
}

Map<String, dynamic> _$RenameFileRequestToJson(RenameFileRequest instance) =>
    <String, dynamic>{
      'type': instance.type,
      'path': instance.path,
      'name': instance.name,
      'newName': instance.newName,
      'isLink': instance.isLink,
      'isFolder': instance.isFolder,
    };
