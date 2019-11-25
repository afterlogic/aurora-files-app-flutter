import 'package:json_annotation/json_annotation.dart';

part 'upload_file_request.g.dart';

@JsonSerializable()
class UploadFileRequest {
  @JsonKey(name: "Type")
  final String storageType;
  @JsonKey(name: "Path")
  final String path;
  @JsonKey(name: "SubPath")
  final String subPath = "";
  @JsonKey(name: "Overwrite")
  final bool overwrite = false;
  @JsonKey(name: "ExtendedProps")
  ExtendedProps extendedProps;

  UploadFileRequest(this.storageType, this.path);

  factory UploadFileRequest.fromJson(Map<String, dynamic> json) =>
      _$UploadFileRequestFromJson(json);

  Map<String, dynamic> toJson() => _$UploadFileRequestToJson(this);
}

@JsonSerializable()
class ExtendedProps {
  @JsonKey(name: "InitializationVector")
  final String iv;
  @JsonKey(name: "FirstChunk")
  final bool firstChunk = true;

  ExtendedProps(this.iv);

  factory ExtendedProps.fromJson(Map<String, dynamic> json) =>
      _$ExtendedPropsFromJson(json);

  Map<String, dynamic> toJson() => _$ExtendedPropsToJson(this);
}
