// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'storage.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Storage _$StorageFromJson(Map<String, dynamic> json) {
  return Storage()
    ..type = json['type'] as String
    ..displayName = json['displayName'] as String
    ..isExternal = json['isExternal'] as bool
    ..order = json['order'] as int
    ..isDroppable = json['isDroppable'] as bool;
}

Map<String, dynamic> _$StorageToJson(Storage instance) => <String, dynamic>{
      'type': instance.type,
      'displayName': instance.displayName,
      'isExternal': instance.isExternal,
      'order': instance.order,
      'isDroppable': instance.isDroppable,
    };
