import 'package:domain/model/bd/storage.dart';
import 'package:domain/model/network/file/files_response.dart';
import 'package:domain/model/network/file/upload_file_request.dart';

abstract class FilesNetworkApi {
  Future<List<Storage>> getStorages();

  Future<FilesResponse> getFiles(String type, String path, String pattern);

  Future upload(UploadFileRequest request, Stream<List<int>> stream, int length,
      String filename);

  Future<Stream<List<int>>> download(String url);
}
