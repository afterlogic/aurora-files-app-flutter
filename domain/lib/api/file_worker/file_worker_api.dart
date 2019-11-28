import 'dart:io';

import 'package:domain/model/bd/local_file.dart';
import 'package:domain/model/data/processing_file.dart';

abstract class FileWorkerApi {
  Future<Stream<double>> uploadFile(
    ProcessingFile processingFile,
    String url,
    String storageType,
    String path, {
    String encryptKey,
  });

  Future<Stream<double>> downloadFile(
    String url,
    LocalFile file,
    String encryptKey,
    ProcessingFile processingFile, {
    Function(File) onSuccess,
  });
}
