import 'package:domain/model/bd/storage.dart';
import 'package:domain/model/data/recipient.dart';
import 'package:domain/model/network/file/copy_file_request.dart';
import 'package:domain/model/network/file/create_folder_request.dart';
import 'package:domain/model/network/file/create_public_link_reqest.dart';
import 'package:domain/model/network/file/delete_request.dart';
import 'package:domain/model/network/file/get_files_request.dart';
import 'package:domain/model/network/file/rename_file_request.dart';
import 'package:domain/model/network/file/files_response.dart';
import 'package:domain/model/network/file/upload_file_request.dart';

abstract class FilesNetworkApi {
  Future<List<Storage>> getStorages();

  Future<FilesResponse> getFiles(GetFilesRequest request);

  Future renameFile(RenameFileRequest request);

  Future<Stream<List<int>>> upload(UploadFileRequest request, Stream<List<int>> stream, int length,
      String filename);

  Future<Stream<List<int>>> download(String url);

  Future createFolder(CreateFolderRequest request);

  Future delete(DeleteRequest request);

  Future<String> createPublicLink(PublicLinkRequest request);

  Future deletePublicLink(PublicLinkRequest request);

  Future copyFilesTo(CopyFileRequest request);

  Future<List<Recipient>> getRecipient();
}
