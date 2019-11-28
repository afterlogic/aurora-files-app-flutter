import 'package:json_annotation/json_annotation.dart';

part 'get_files_request.g.dart';

@JsonSerializable()
class GetFilesRequest {
  final String type;
  final String path;
  final String pattern;

  final bool pathRequired = false;

  GetFilesRequest(this.type, this.path, String pattern)
      : pattern = pattern.toLowerCase().trim();

  factory GetFilesRequest.fromJson(Map<String, dynamic> json) =>
      _$GetFilesRequestFromJson(json);

  Map<String, dynamic> toJson() => _$GetFilesRequestToJson(this);
}
