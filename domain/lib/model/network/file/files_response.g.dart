// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'files_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FilesResponse _$FilesResponseFromJson(Map<String, dynamic> json) {
  return FilesResponse(
    (json['Items'] as List)
        ?.map((e) =>
            e == null ? null : LocalFile.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    json['Quota'] == null
        ? null
        : Quota.fromJson(json['Quota'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$FilesResponseToJson(FilesResponse instance) =>
    <String, dynamic>{
      'Items': instance.items,
      'Quota': instance.quota,
    };
