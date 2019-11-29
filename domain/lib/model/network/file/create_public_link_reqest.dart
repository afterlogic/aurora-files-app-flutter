import 'package:json_annotation/json_annotation.dart';

part 'create_public_link_reqest.g.dart';

@JsonSerializable()
class PublicLinkRequest {
  final int userId;
  final String type;
  final String path;
  final String name;
  final int size;
  final bool isFolder;

  PublicLinkRequest(
    this.userId,
    this.type,
    this.path,
    this.name,
    this.size,
    this.isFolder,
  );

  PublicLinkRequest.fill({
    this.userId,
    this.type,
    this.path,
    this.name,
    this.size,
    this.isFolder,
  });

  factory PublicLinkRequest.fromJson(Map<String, dynamic> json) =>
      _$PublicLinkRequestFromJson(json);

  Map<String, dynamic> toJson() => _$PublicLinkRequestToJson(this);
}
