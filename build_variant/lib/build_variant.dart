import 'dart:io';

import 'src/flag_builder.dart';
import 'src/property_builder.dart';

import 'src/parse_variable.dart';

buildVariant(
  Directory directory,
  String variablePath,
) async {
  try {
    final List<String> filesPath = [];
    final variableFile = File((directory.path + "/" + variablePath)
        .replaceAll(RegExp("\/|\\\\"), Platform.pathSeparator));

    final variableMap = await ParseVariable(variableFile).parse();

    final files = variableMap.listVariable.firstWhere(
      (item) => item.key == "_files",
      orElse: () => null,
    );

    if (files != null) {
      filesPath.addAll(files.value.map((item) => item.toString()));
    }

    var buildPropertyPath = variableMap.stringVariable
        .firstWhere((item) => item.key == "_buildPropertyPath", orElse: () => null)
        ?.value;

    buildPropertyPath ??= "lib/build_const.dart";

    final buildConstFile = File((directory.path + "/" + buildPropertyPath)
        .replaceAll(RegExp("\/|\\\\"), Platform.pathSeparator));

    await PropertyBuilder(buildConstFile, variableMap).build();

    for (var path in filesPath) {
      final file = File((directory.path + "/" + path)
          .replaceAll(RegExp("\/|\\\\"), Platform.pathSeparator));
      await FlagBuilder(file, variableMap).build();
    }
  } catch (e) {
    print("ERROR_________________________________");
    print(e);
  }
}
