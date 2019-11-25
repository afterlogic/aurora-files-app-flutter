import 'network_route.dart';

class ModuleCore extends NetworkRoute {
  @override
  final String module = "Core";
  @override
  final Map<String, dynamic> parameters;

  ModuleCore(CoreMethod method, {this.parameters}) : super(method);
}

enum CoreMethod { Login }
