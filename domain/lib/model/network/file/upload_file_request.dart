import 'package:json_annotation/json_annotation.dart';

part 'upload_file_request.g.dart';

@JsonSerializable()
class UploadFileRequest {
  final String type;
  final String path;
  final String subPath = "";
  final bool overwrite = false;

  ExtendedProps extendedProps;

  UploadFileRequest(this.type, this.path);

  factory UploadFileRequest.fromJson(Map<String, dynamic> json) =>
      _$UploadFileRequestFromJson(json);

  Map<String, dynamic> toJson() => _$UploadFileRequestToJson(this);
}

@JsonSerializable()
class ExtendedProps {
  final String initializationVector;
  final bool firstChunk = true;

  ExtendedProps(this.initializationVector);

  factory ExtendedProps.fromJson(Map<String, dynamic> json) =>
      _$ExtendedPropsFromJson(json);

  Map<String, dynamic> toJson() => _$ExtendedPropsToJson(this);
}
