import 'network_route.dart';

class ModuleFiles extends NetworkRoute {
  @override
  final String module = "Files";
  @override
  final Map<String, dynamic> parameters;

  ModuleFiles(CoreMethod method, {this.parameters}) : super(method);
}

enum CoreMethod { UploadFile }
