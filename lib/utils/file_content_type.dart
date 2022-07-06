import 'package:aurorafiles/database/app_database.dart';

enum FileType {
  unknown,
  text,
  code,
  pdf,
  zip,
  image,
  svg,
}

FileType getFileType(LocalFile file) {
  if (file.contentType.startsWith("image/svg")) return FileType.svg;
  if (file.contentType.startsWith("image")) return FileType.image;

  switch (file.contentType) {
    case "text/plain":
    case "message/rfc822":
      return FileType.text;
    case "text/html":
    case "application/javascript":
    case "application/xml":
    case "application/json":
      return FileType.code;
    case "application/zip":
      return FileType.zip;
    case "application/pdf":
      return FileType.pdf;
    default:
      return FileType.unknown;
  }
}
