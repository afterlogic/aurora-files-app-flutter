import 'package:json_annotation/json_annotation.dart';

part 'create_folder_request.g.dart';

@JsonSerializable()
class CreateFolderRequest {
  final String type;
  final String path;
  final String folderName;

  CreateFolderRequest(this.type, this.path, this.folderName);

  factory CreateFolderRequest.fromJson(Map<String, dynamic> json) =>
      _$CreateFolderRequestFromJson(json);

  Map<String, dynamic> toJson() => _$CreateFolderRequestToJson(this);
}
