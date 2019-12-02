// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'local_file.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LocalFile _$LocalFileFromJson(Map<String, dynamic> json) {
  return LocalFile()
    ..localId = json['localId'] as int
    ..id = json['id'] as String
    ..guid = json['guid'] as String
    ..type = json['type'] as String
    ..path = json['path'] as String
    ..fullPath = json['fullPath'] as String
    ..localPath = json['localPath'] as String
    ..name = json['name'] as String
    ..size = json['size'] as int
    ..isFolder = json['isFolder'] as bool
    ..isOpenable = json['isOpenable'] as bool
    ..isLink = json['isLink'] as bool
    ..linkType = json['linkType'] as String
    ..linkUrl = json['linkUrl'] as String
    ..lastModified = json['lastModified'] as int
    ..contentType = json['contentType'] as String
    ..oEmbedHtml = json['oEmbedHtml'] as String
    ..published = json['published'] as bool
    ..owner = json['owner'] as String
    ..content = json['content'] as String
    ..viewUrl = json['viewUrl'] as String
    ..downloadUrl = json['downloadUrl'] as String
    ..thumbnailUrl = json['thumbnailUrl'] as String
    ..hash = json['hash'] as String
    ..actions = json['actions'] as Map<String, dynamic>
    ..extendedProps = LocalFile.toExtendedProps(json['extendedProps'])
    ..isExternal = json['isExternal'] as bool
    ..initVector = json['initVector'] as String;
}

Map<String, dynamic> _$LocalFileToJson(LocalFile instance) => <String, dynamic>{
      'localId': instance.localId,
      'id': instance.id,
      'guid': instance.guid,
      'type': instance.type,
      'path': instance.path,
      'fullPath': instance.fullPath,
      'localPath': instance.localPath,
      'name': instance.name,
      'size': instance.size,
      'isFolder': instance.isFolder,
      'isOpenable': instance.isOpenable,
      'isLink': instance.isLink,
      'linkType': instance.linkType,
      'linkUrl': instance.linkUrl,
      'lastModified': instance.lastModified,
      'contentType': instance.contentType,
      'oEmbedHtml': instance.oEmbedHtml,
      'published': instance.published,
      'owner': instance.owner,
      'content': instance.content,
      'viewUrl': instance.viewUrl,
      'downloadUrl': instance.downloadUrl,
      'thumbnailUrl': instance.thumbnailUrl,
      'hash': instance.hash,
      'actions': instance.actions,
      'extendedProps': instance.extendedProps,
      'isExternal': instance.isExternal,
      'initVector': instance.initVector,
    };
