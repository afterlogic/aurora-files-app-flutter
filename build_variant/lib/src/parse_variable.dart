import 'dart:io';

import 'variable_map.dart';
import 'package:yaml/yaml.dart';

class ParseVariable {
  final File file;

  ParseVariable(this.file);

  Future<VariableMap> parse() async {
    final content = await file.readAsString();
    final yaml = loadYaml(content);

    return VariableMap.fromMap(yaml);
  }
}
