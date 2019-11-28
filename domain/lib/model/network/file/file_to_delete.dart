import 'package:json_annotation/json_annotation.dart';

part 'file_to_delete.g.dart';

@JsonSerializable()
class FileToDelete {
  final String type;
  final String path;
  final String name;
  final bool isFolder;

  FileToDelete(
    this.path,
    this.name,
    this.isFolder,
    this.type,
  );

  factory FileToDelete.fromJson(Map<String, dynamic> json) =>
      _$FileToDeleteFromJson(json);

  Map<String, dynamic> toJson() => _$FileToDeleteToJson(this);
}
