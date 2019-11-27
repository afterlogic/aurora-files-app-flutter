import 'dart:async';
import 'dart:io';

enum ProcessingType {
  upload,
  download,
  share,
  offline,
  cacheImage,
  cacheToDelete,
}

class ProcessingFile {
  final String guid;
  final String name;
  final File fileOnDevice;
  final int size;
  final ProcessingType processingType;

  ProcessingFile(
    this.guid,
    this.name,
    this.fileOnDevice,
    this.size,
    this.processingType,
  );
}
