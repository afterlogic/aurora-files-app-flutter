// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_files_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GetFilesRequest _$GetFilesRequestFromJson(Map<String, dynamic> json) {
  return GetFilesRequest(
    json['type'] as String,
    json['path'] as String,
    json['pattern'] as String,
  );
}

Map<String, dynamic> _$GetFilesRequestToJson(GetFilesRequest instance) =>
    <String, dynamic>{
      'type': instance.type,
      'path': instance.path,
      'pattern': instance.pattern,
    };
