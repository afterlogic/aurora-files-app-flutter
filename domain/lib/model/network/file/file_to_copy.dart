import 'package:json_annotation/json_annotation.dart';

part 'file_to_copy.g.dart';

@JsonSerializable()
class FileToMove{
  final String fromType;
  final String fromPath;
  final String name;
  final bool isFolder;

  FileToMove(this.fromType, this.fromPath, this.name, this.isFolder);

  factory FileToMove.fromJson(Map<String, dynamic> json) =>
      _$FileToMoveFromJson(json);

  Map<String, dynamic> toJson() => _$FileToMoveToJson(this);
}