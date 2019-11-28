// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'file_to_delete.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FileToDelete _$FileToDeleteFromJson(Map<String, dynamic> json) {
  return FileToDelete(
    json['path'] as String,
    json['name'] as String,
    json['isFolder'] as bool,
    json['type'] as String,
  );
}

Map<String, dynamic> _$FileToDeleteToJson(FileToDelete instance) =>
    <String, dynamic>{
      'type': instance.type,
      'path': instance.path,
      'name': instance.name,
      'isFolder': instance.isFolder,
    };
