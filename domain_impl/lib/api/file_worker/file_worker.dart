import 'package:domain/api/file_worker/file_worker_api.dart';
import 'package:domain/model/network/file/processing_file.dart';
import 'package:domain/api/file_worker/error/file_error.dart';
import 'package:domain/model/network/file/upload_file_request.dart';
import 'package:encrypt/encrypt.dart';

class FileWorker extends FileWorkerApi {
  Stream<int> uploadFile(
    ProcessingFile processingFile,
    bool shouldEncrypt, {
    String url,
    String storageType,
    String path,
  }) async* {
    final bool fileExists = await processingFile.fileOnDevice.exists();

    if (!fileExists) {
      throw FileError(
        FileErrorCase.NotExist,
        "File to download data into doesn't exist",
      );
    }

    final uploadRequest = UploadFileRequest(storageType, path);
    if (shouldEncrypt == true) {
      final vector = IV.fromSecureRandom(_vectorLength);
      processingFile.ivBase64 = vector.base64;
      uploadRequest.extendedProps = ExtendedProps(vector.base16);
    }

    final body = new ApiBody(
            module: "Files",
            method: "UploadFile",
            parameters: jsonEncode(params))
        .toMap();

    final stream = new http.ByteStream(
        _openFileRead(processingFile, shouldEncrypt, onError));
    final length = await processingFile.fileOnDevice.length();
    final lengthWithPadding =
        ((length / vectorLength) + 1).toInt() * vectorLength;

    final uri = Uri.parse(url);

    final requestMultipart = new http.MultipartRequest("POST", uri);
    final multipartFile = new http.MultipartFile(
        'file', stream, shouldEncrypt ? lengthWithPadding : length,
        filename:
            FileUtils.getFileNameFromPath(processingFile.fileOnDevice.path));

    requestMultipart.headers.addAll(getHeader());

    requestMultipart.fields.addAll(body);
    requestMultipart.files.add(multipartFile);

    final response = await requestMultipart.send();
    final result = await response.stream.bytesToString();
    Map<String, dynamic> res = json.decode(result);

    if (res["Result"] == null || res["Result"] == false) {
      onError(getErrMsg(res));
    } else {
      processingFile.endProcess();
      onSuccess();
    }
  }

  static const _vectorLength = 16;
}
