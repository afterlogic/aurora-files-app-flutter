import 'network_route.dart';

class ModuleCore extends NetworkRoute {
  @override
  final String module = "Core";
  @override
  final Map<String, dynamic> parameters;

  ModuleCore(CoreMethod method, {this.parameters, bool toUpperCase})
      : super(method, toUpperCase);
}

enum CoreMethod { Login }
