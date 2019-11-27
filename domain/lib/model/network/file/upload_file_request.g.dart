// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'upload_file_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UploadFileRequest _$UploadFileRequestFromJson(Map<String, dynamic> json) {
  return UploadFileRequest(
    json['Type'] as String,
    json['Path'] as String,
  )..extendedProps = json['ExtendedProps'] == null
      ? null
      : ExtendedProps.fromJson(json['ExtendedProps'] as Map<String, dynamic>);
}

Map<String, dynamic> _$UploadFileRequestToJson(UploadFileRequest instance) =>
    <String, dynamic>{
      'Type': instance.storageType,
      'Path': instance.path,
      'ExtendedProps': instance.extendedProps,
    };

ExtendedProps _$ExtendedPropsFromJson(Map<String, dynamic> json) {
  return ExtendedProps(
    json['InitializationVector'] as String,
  );
}

Map<String, dynamic> _$ExtendedPropsToJson(ExtendedProps instance) =>
    <String, dynamic>{
      'InitializationVector': instance.iv,
    };
