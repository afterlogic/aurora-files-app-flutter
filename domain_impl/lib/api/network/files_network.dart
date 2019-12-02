import 'dart:io';

import 'package:dio/dio.dart';
import 'package:domain/api/cache/storage/user_storage_api.dart';
import 'package:domain/model/bd/storage.dart';
import 'package:domain/model/data/recipient.dart';
import 'package:domain/model/network/file/copy_file_request.dart';
import 'package:domain/model/network/file/create_folder_request.dart';
import 'package:domain/model/network/file/create_public_link_reqest.dart';
import 'package:domain/model/network/file/delete_request.dart';
import 'package:domain/model/network/file/files_response.dart';
import 'package:domain/api/network/files_network_api.dart';
import 'package:domain/model/network/file/get_files_request.dart';
import 'package:domain/model/network/file/upload_file_request.dart';
import 'package:domain_impl/api/network/route/module_contacts.dart';
import 'package:domain_impl/api/network/route/module_files.dart';
import 'package:domain_impl/api/network/util/map_util.dart';
import 'package:http/http.dart' as http;

import 'dio/interceptor/auth_interceptor.dart';
import 'package:domain/model/network/file/rename_file_request.dart';

class FilesNetwork implements FilesNetworkApi {
  final Dio _dio;
  final UserStorageApi _userStorageApi;

  FilesNetwork(this._dio, this._userStorageApi);

  Future<List<Storage>> getStorages() async {
    final route = ModuleFiles(
      FilesMethod.GetStorages,
    );
    final result = await _dio.post("/?Api/", data: route.toJson());
    return (result.data as List).map((json) => Storage.fromJson(json)).toList();
  }

  Future<FilesResponse> getFiles(GetFilesRequest request) async {
    final route = ModuleFiles(
      FilesMethod.GetFiles,
      parameters: request.toJson(),
      toUpperCase: true,
    );

    final result = await _dio.post("/?Api/", data: route.toJson());
    keysToLowerCase(result.data["quota"]);
    return FilesResponse.fromJson(result.data);
  }

  Future renameFile(RenameFileRequest request) async {
    final route = ModuleFiles(
      FilesMethod.Rename,
      parameters: request.toJson(),
      toUpperCase: true,
    );
    await _dio.post("/?Api/", data: route.toJson());
    return request.newName;
  }

  Future<Stream<List<int>>> upload(
    UploadFileRequest request,
    Stream<List<int>> stream,
    int length,
    String filename,
  ) async {
    final uri = Uri.parse(_dio.options.baseUrl);

    final route = ModuleFiles(
      FilesMethod.UploadFile,
      parameters: request.toJson(),
      toUpperCase: true,
    );

    final headers = _dio.options.headers;
    headers["Authorization"] = AuthInterceptor.token(_userStorageApi);

    final multipartRequest = http.MultipartRequest("POST", uri);
    final file = http.MultipartFile("file", stream, length, filename: filename);

    multipartRequest.headers.addAll(
        headers.map((key, value) => MapEntry<String, String>(key, value)));
    multipartRequest.fields.addAll(route
        .toJson()
        .map((key, value) => MapEntry<String, String>(key, value)));
    multipartRequest.files.add(file);

    return (await multipartRequest.send()).stream;
  }

  Future<Stream<List<int>>> download(
    String url, [
    bool isRedirect = false,
  ]) async {
    final client = HttpClient();
    final host = _dio.options.baseUrl;
    final HttpClientRequest request =
        await client.getUrl(Uri.parse(isRedirect ? url : host + url));

    request.followRedirects = false;
    if (!isRedirect) {
      request.headers
          .add("Authorization", AuthInterceptor.token(_userStorageApi));
    }
    final HttpClientResponse response = await request.close();
    if (response.isRedirect) {
      return download(response.headers.value("location"), true);
    }

    return response;
  }

  Future createFolder(CreateFolderRequest request) async {
    final route = ModuleFiles(
      FilesMethod.CreateFolder,
      parameters: request.toJson(),
      toUpperCase: true,
    );

    await _dio.post("/?Api/", data: route.toJson());
  }

  Future delete(DeleteRequest request) async {
    final route = ModuleFiles(
      FilesMethod.Delete,
      parameters: request.toJson(),
      toUpperCase: true,
    );

    await _dio.post("/?Api/", data: route.toJson());
  }

  Future<String> createPublicLink(
    PublicLinkRequest request,
  ) async {
    final route = ModuleFiles(
      FilesMethod.CreatePublicLink,
      parameters: request.toJson(),
      toUpperCase: true,
    );

    final response = await _dio.post("/?Api/", data: route.toJson());

    return "${_dio.options.baseUrl}/$response";
  }

  Future deletePublicLink(PublicLinkRequest request) async {
    final route = ModuleFiles(
      FilesMethod.DeletePublicLink,
      parameters: request.toJson(),
      toUpperCase: true,
    );

    final response = await _dio.post("/?Api/", data: route.toJson());

    return "${_dio.options.baseUrl}/$response";
  }

  Future copyFilesTo(CopyFileRequest request) async {
    final route = ModuleFiles(
      request.copy == true ? FilesMethod.Copy : FilesMethod.Move,
      parameters: request.toJson(),
      toUpperCase: true,
    );

    await _dio.post("/?Api/", data: route.toJson());
  }

  Future<List<Recipient>> getRecipient() async {
    //todo static request for test
    final parameters = {
      "Search": "",
      "Storage": "all",
      "SortField": 3,
      "SortOrder": 1,
      "WithGroups": false,
      "WithoutTeamContactsDuplicates": true
    };

    final route = ModuleContacts(
      ContactsMethod.GetContacts,
      parameters: parameters,
      toUpperCase: true,
    );

    final response = await _dio.post("/?Api/", data: route.toJson());

    return (response.data["List"] as List)
        .map((item) => Recipient.fromJson(item))
        .toList();
  }
}
