import 'dart:async';
import 'dart:io';

import 'package:domain/api/crypto/aes_crypto_api.dart';
import 'package:domain/api/file_worker/file_load_worker_api.dart';
import 'package:domain/api/network/files_network_api.dart';
import 'package:domain/model/bd/local_file.dart';
import 'package:domain/model/data/processing_file.dart';
import 'package:domain/api/file_worker/error/file_error.dart';
import 'package:domain/model/network/file/upload_file_request.dart';
import 'package:encrypt/encrypt.dart';

class FileLoadWorker extends FileLoadWorkerApi {
  final FilesNetworkApi _filesNetworkApi;
  final AesCryptoApi _aesCrypto;

  FileLoadWorker(this._filesNetworkApi, this._aesCrypto);

  Future<Stream<double>> uploadFile(
    ProcessingFile processingFile,
    String storageType,
    String path, {
    String encryptKey,
  }) async {
    if (!await processingFile.fileOnDevice.exists()) {
      throw FileError(FileErrorCase.NotExist, "File doesn't exist");
    }

    final uploadRequest = UploadFileRequest(storageType, path);

    final shouldEncrypt = encryptKey != null;

    var fileLength = await processingFile.fileOnDevice.length();
    if (shouldEncrypt) {
      fileLength = ((fileLength / _vectorLength) + 1).toInt() * _vectorLength;
    }

    var currentBytes = 0;
    var currentProgress = 0.0;
    final fileStream = processingFile.fileOnDevice.openRead().map((bytes) {
      currentBytes += bytes.length;

      currentProgress = currentBytes / fileLength;
      return bytes;
    });

    var outStream = fileStream;
    if (shouldEncrypt) {
      final vector = IV.fromSecureRandom(_vectorLength);
      uploadRequest.extendedProps = ExtendedProps(vector.base16);

      outStream = _aesCrypto.encryptStream(
        outStream,
        encryptKey,
        processingFile.ivBase64 ?? vector.base64,
        _vectorLength,
        (v) {
          processingFile.ivBase64 = v;
        },
      );
    }

    final fileName = _getFileName(processingFile.fileOnDevice.path);

    return (await _filesNetworkApi.upload(
            uploadRequest, outStream, fileLength, fileName))
        .map((_) {
      return currentProgress;
    });
  }

  Future<Stream<double>> downloadFile(
    String url,
    LocalFile file,
    String encryptKey,
    ProcessingFile processingFile, {
    Function(File) onSuccess,
  }) async {
    if (!await processingFile.fileOnDevice.exists()) {
      throw FileError(FileErrorCase.NotExist, "File doesn't exist");
    }

    final shouldDecrypt = file.initVector != null;

    final networkStream = await _filesNetworkApi.download(url);

    var outStream = networkStream;
    if (shouldDecrypt) {
      IV iv = IV.fromBase16(file.initVector);
      outStream = _aesCrypto.decryptStream(
        outStream,
        encryptKey,
        processingFile.ivBase64 ?? iv.base64,
        _vectorLength,
        (v) {},
      );
    }

    var currentBytes = 0;
    return _writeToFile(outStream, processingFile.fileOnDevice).map((bytes) {
      currentBytes += bytes.length;
      return currentBytes / file.size;
    }).handleError((_, __) {
      processingFile.fileOnDevice.delete(recursive: true);
    });
  }

  Stream<List<int>> _writeToFile(Stream<List<int>> stream, File file) {
    return stream.asyncMap((bytes) async {
      file.writeAsBytes(bytes, mode: FileMode.append);
      return bytes;
    });
  }

  String _getFileName(String path) {
    final index = path.lastIndexOf("/");
    return path.substring(index + 1);
  }

  static const _vectorLength = 16;
}
