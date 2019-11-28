// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'files_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FilesResponse _$FilesResponseFromJson(Map<String, dynamic> json) {
  return FilesResponse(
    (json['items'] as List)
        ?.map((e) =>
            e == null ? null : LocalFile.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    json['quota'] == null
        ? null
        : Quota.fromJson(json['quota'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$FilesResponseToJson(FilesResponse instance) =>
    <String, dynamic>{
      'items': instance.items,
      'quota': instance.quota,
    };
