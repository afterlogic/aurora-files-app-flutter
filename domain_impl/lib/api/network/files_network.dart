import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:domain/api/cache/storage/user_storage_api.dart';
import 'package:domain/api/network/error/network_error.dart';
import 'package:domain/model/bd/storage.dart';
import 'package:domain/model/network/file/files_response.dart';
import 'package:domain/api/network/files_network_api.dart';
import 'package:domain/model/network/file/upload_file_request.dart';
import 'package:domain_impl/api/network/route/module_files.dart';
import 'package:http/http.dart' as http;

import 'dio/interceptor/auth_interceptor.dart';

class FilesNetwork implements FilesNetworkApi {
  final Dio _dio;
  final UserStorageApi _userStorageApi;

  FilesNetwork(this._dio, this._userStorageApi);

  Future<List<Storage>> getStorages() {}

  Future<FilesResponse> getFiles(String type, String path, String pattern) {}

  upload(UploadFileRequest request, Stream<List<int>> stream, int length,
      String filename) async {
    final uri = Uri.parse(_dio.options.baseUrl);

    final route =
    ModuleFiles(CoreMethod.UploadFile, parameters: request.toJson());

    final headers = _dio.options.headers;
    AuthInterceptor.addToken(headers, _userStorageApi);

    final multipartRequest = http.MultipartRequest("POST", uri);
    final file = http.MultipartFile("file", stream, length, filename: filename);

    multipartRequest.headers.addAll(headers);
    multipartRequest.fields.addAll(route.toJson());
    multipartRequest.files.add(file);

    final response = await multipartRequest.send();
    final result = json.decode(await response.stream.bytesToString());

    if (result["Result"] == null || result["Result"] == false) {
      throw NetworkError(NetworkErrorCase.Undefined);
    }
  }
}
