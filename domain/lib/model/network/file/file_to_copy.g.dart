// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'file_to_copy.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FileToMove _$FileToMoveFromJson(Map<String, dynamic> json) {
  return FileToMove(
    json['fromType'] as String,
    json['fromPath'] as String,
    json['name'] as String,
    json['isFolder'] as bool,
  );
}

Map<String, dynamic> _$FileToMoveToJson(FileToMove instance) =>
    <String, dynamic>{
      'fromType': instance.fromType,
      'fromPath': instance.fromPath,
      'name': instance.name,
      'isFolder': instance.isFolder,
    };
