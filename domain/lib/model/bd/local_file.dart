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
  Map<String, dynamic> actions;
  @JsonKey(fromJson: toExtendedProps)
  String extendedProps;
  bool isExternal;
  String initVector;

  LocalFile();

  static String toExtendedProps(object) {
    return object.toString();
  }

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

  factory LocalFile.fromJson(Map<String, dynamic> json) {
    final file = _$LocalFileFromJson(json);
    try {
      file.viewUrl = file.actions["view"]["url"];
      file.downloadUrl = file.actions["download"]["url"];
    } catch (_) {}
    return file;
  }

  Map<String, dynamic> toJson() => _$LocalFileToJson(this);

  factory LocalFile.getFolderFromName(
    String name,
    String path,
    String storageType,
    String userEmail,
  ) {
    return new LocalFile.fill(
      localId: null,
      id: name,
      guid: null,
      type: storageType,
      path: path,
      fullPath: path.isEmpty ? "/" + name : "$path/$name",
      localPath: null,
      name: name,
      size: 0,
      isFolder: true,
      isOpenable: true,
      isLink: false,
      linkType: "",
      linkUrl: "",
      lastModified: 0,
      contentType: "",
      oEmbedHtml: "",
      published: false,
      owner: userEmail,
      content: "",
      viewUrl: null,
      downloadUrl: null,
      hash: null,
      extendedProps: "[]",
      isExternal: false,
    );
  }
}
