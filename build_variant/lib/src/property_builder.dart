import 'dart:io';

import 'package:dart_style/dart_style.dart';

import 'util/file_util.dart';
import 'variable_map.dart';

class PropertyBuilder {
  final File outputFile;
  final VariableMap variableMap;
  final dartFormatted = DartFormatter();

  PropertyBuilder(this.outputFile, this.variableMap);

  Future build() async {
    var content = "";
    content += "class BuildProperty {";

    for (var variable in variableMap.getPublic()) {
      content += "\n" +
          "static const ${variable.key} = ${variable.valueString};" +
          "\n";
    }

    content += "}";

    await deleteIfExist(outputFile);
    await outputFile.create();

    await outputFile.writeAsString(dartFormatted.format(content));
  }
}
