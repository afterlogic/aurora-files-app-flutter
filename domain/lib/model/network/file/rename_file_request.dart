import 'package:json_annotation/json_annotation.dart';

part 'rename_file_request.g.dart';

@JsonSerializable()
class RenameFileRequest {
  final String type;
  final String path;
  final String name;
  final String newName;
  final bool isLink;
  final bool isFolder;

  RenameFileRequest(
    this.type,
    this.path,
    this.name,
    this.newName,
    this.isLink,
    this.isFolder,
  );

  RenameFileRequest.fill({
    this.type,
    this.path,
    this.name,
    this.newName,
    this.isLink,
    this.isFolder,
  });

  factory RenameFileRequest.fromJson(Map<String, dynamic> json) =>
      _$RenameFileRequestFromJson(json);

  Map<String, dynamic> toJson() => _$RenameFileRequestToJson(this);
}
