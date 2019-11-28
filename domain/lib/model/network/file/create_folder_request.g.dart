// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_folder_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CreateFolderRequest _$CreateFolderRequestFromJson(Map<String, dynamic> json) {
  return CreateFolderRequest(
    json['type'] as String,
    json['path'] as String,
    json['folderName'] as String,
  );
}

Map<String, dynamic> _$CreateFolderRequestToJson(
        CreateFolderRequest instance) =>
    <String, dynamic>{
      'type': instance.type,
      'path': instance.path,
      'folderName': instance.folderName,
    };
