// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'copy_file_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CopyFileRequest _$CopyFileRequestFromJson(Map<String, dynamic> json) {
  return CopyFileRequest(
    json['copy'] as bool,
    json['fromType'] as String,
    json['toType'] as String,
    json['fromPath'] as String,
    json['toPath'] as String,
    (json['files'] as List)
        ?.map((e) =>
            e == null ? null : FileToMove.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  );
}

Map<String, dynamic> _$CopyFileRequestToJson(CopyFileRequest instance) =>
    <String, dynamic>{
      'copy': instance.copy,
      'fromType': instance.fromType,
      'toType': instance.toType,
      'fromPath': instance.fromPath,
      'toPath': instance.toPath,
      'files': instance.files,
    };
