import 'package:domain/model/network/file/file_to_copy.dart';
import 'package:json_annotation/json_annotation.dart';

part 'copy_file_request.g.dart';

@JsonSerializable()
class CopyFileRequest {
  final bool copy;
  final String fromType;
  final String toType;
  final String fromPath;
  final String toPath;
  final List<FileToMove> files;

  CopyFileRequest(this.copy, this.fromType, this.toType, this.fromPath, this.toPath, this.files);

  CopyFileRequest.fill({this.copy, this.fromType, this.toType, this.fromPath, this.toPath, this.files});

  factory CopyFileRequest.fromJson(Map<String, dynamic> json) =>
      _$CopyFileRequestFromJson(json);

  Map<String, dynamic> toJson() => _$CopyFileRequestToJson(this);
}
