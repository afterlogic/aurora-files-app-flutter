// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'storage.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Storage _$StorageFromJson(Map<String, dynamic> json) {
  return Storage()
    ..type = json['Type'] as String
    ..displayName = json['DisplayName'] as String
    ..isExternal = json['IsExternal'] as bool
    ..order = json['Order'] as int
    ..isDroppable = json['IsDroppable'] as bool;
}

Map<String, dynamic> _$StorageToJson(Storage instance) => <String, dynamic>{
      'Type': instance.type,
      'DisplayName': instance.displayName,
      'IsExternal': instance.isExternal,
      'Order': instance.order,
      'IsDroppable': instance.isDroppable,
    };
