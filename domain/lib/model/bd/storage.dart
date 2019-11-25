import 'package:json_annotation/json_annotation.dart';

part 'storage.g.dart';

@JsonSerializable()
class Storage {
  @JsonKey(name: "Type")
  String type;
  @JsonKey(name: "DisplayName")
  String displayName;
  @JsonKey(name: "IsExternal")
  bool isExternal;
  @JsonKey(name: "Order")
  int order;
  @JsonKey(name: "IsDroppable")
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
}
