import 'network_route.dart';

class ModuleFiles extends NetworkRoute {
  @override
  final String module = "Files";
  @override
  final Map<String, dynamic> parameters;

  ModuleFiles(FilesMethod method, {this.parameters, bool toUpperCase})
      : super(method, toUpperCase);
}

enum FilesMethod {
  UploadFile,
  Rename,
  CreateFolder,
  Delete,
  CreatePublicLink,
  DeletePublicLink,
  GetStorages,
  GetFiles,
  Copy,
  Move,
}
