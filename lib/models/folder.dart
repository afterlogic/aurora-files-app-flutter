class FoldersResult {
  final String namespace;
  final List<Folder> folders;

  FoldersResult(this.namespace, this.folders);

  factory FoldersResult.fromJson(Map item) {
    return FoldersResult(
      item["Namespace"],
      (item["Folders"]["@Collection"] as List)
          .map((item) => Folder.fromJson(item))
          .toList(),
    );
  }
}

class Folder {
  final String fullName;
  final int type;
  final String delimiter;

  Folder(this.fullName, this.type, this.delimiter);

  factory Folder.fromJson(Map<String, dynamic> item) {
    return Folder(item["FullName"], item["Type"], item["Delimiter"]);
  }
  static const sendType = 2;
  static const sentFolder = "Sent";
}
