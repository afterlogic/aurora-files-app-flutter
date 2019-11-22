import 'package:json_annotation/json_annotation.dart';

part 'local_file.g.dart';

@JsonSerializable()
class LocalFile {
  int localId;
  String id;
  String guid;
  String type;
  String path;
  String fullPath;
  String localPath;
  String name;
  int size;
  bool isFolder;
  bool isOpenable;
  bool isLink;
  String linkType;
  String linkUrl;
  int lastModified;
  String contentType;
  String oEmbedHtml;
  bool published;
  String owner;
  String content;
  String viewUrl;
  String downloadUrl;
  String thumbnailUrl;
  String hash;
  String extendedProps;
  bool isExternal;
  String initVector;

  LocalFile();

  LocalFile.fill(
      {this.localId,
      this.id,
      this.guid,
      this.type,
      this.path,
      this.fullPath,
      this.localPath,
      this.name,
      this.size,
      this.isFolder,
      this.isOpenable,
      this.isLink,
      this.linkType,
      this.linkUrl,
      this.lastModified,
      this.contentType,
      this.oEmbedHtml,
      this.published,
      this.owner,
      this.content,
      this.viewUrl,
      this.downloadUrl,
      this.thumbnailUrl,
      this.hash,
      this.extendedProps,
      this.isExternal,
      this.initVector});

  factory LocalFile.fromJson(Map<String, dynamic> json) =>
      _$LocalFileFromJson(json);

  Map<String, dynamic> toJson() => _$LocalFileToJson(this);
}