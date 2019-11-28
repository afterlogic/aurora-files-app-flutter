// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'upload_file_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UploadFileRequest _$UploadFileRequestFromJson(Map<String, dynamic> json) {
  return UploadFileRequest(
    json['type'] as String,
    json['path'] as String,
  )..extendedProps = json['extendedProps'] == null
      ? null
      : ExtendedProps.fromJson(json['extendedProps'] as Map<String, dynamic>);
}

Map<String, dynamic> _$UploadFileRequestToJson(UploadFileRequest instance) =>
    <String, dynamic>{
      'type': instance.type,
      'path': instance.path,
      'extendedProps': instance.extendedProps,
    };

ExtendedProps _$ExtendedPropsFromJson(Map<String, dynamic> json) {
  return ExtendedProps(
    json['initializationVector'] as String,
  );
}

Map<String, dynamic> _$ExtendedPropsToJson(ExtendedProps instance) =>
    <String, dynamic>{
      'initializationVector': instance.initializationVector,
    };
