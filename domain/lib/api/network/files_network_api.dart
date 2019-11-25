import 'package:domain/model/bd/storage.dart';
import 'package:domain/model/network/file/files_response.dart';

abstract class FilesNetworkApi {
  Future<List<Storage>> getStorages();

  Future<FilesResponse> getFiles(String type, String path, String pattern);
}
