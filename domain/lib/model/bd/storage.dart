import 'package:json_annotation/json_annotation.dart';

part 'storage.g.dart';

@JsonSerializable()
class Storage {
  String type;
  String displayName;
  bool isExternal;
  int order;
  bool isDroppable;

  Storage();

  Storage.fill({
    this.order,
    this.isDroppable,
    this.type,
    this.displayName,
    this.isExternal,
  });

  factory Storage.fromJson(Map<String, dynamic> json) =>
      _$StorageFromJson(json);

  Map<String, dynamic> toJson() => _$StorageToJson(this);

  factory Storage.fromName(String name) {
    return new Storage.fill(
      type: name,
      displayName: name[0].toUpperCase() + name.substring(1),
      isExternal: false,
      isDroppable: false,
      order: 0,
    );
  }
}
