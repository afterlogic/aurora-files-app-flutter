import 'dart:io';

import 'exception/variable_not_found.dart';
import 'util/file_util.dart';
import 'variable_map.dart';

class FlagBuilder {
  final File dependencyFile;
  final VariableMap variableMap;

  FlagBuilder(this.dependencyFile, this.variableMap);

  Future build() async {
    final mask = getFileExtension(dependencyFile) == "yaml"
        ? _YamlFlagMask()
        : _DartFlagMask();
    final lines =
        (await dependencyFile.readAsString()).split(RegExp("\\r|\\n"));
    List<int> endLines = [];
    for (var index = lines.length - 2; index >= 0; index--) {
      final line = lines[index];
      final ifMatch = mask.startIf.firstMatch(line);

      if (ifMatch != null) {
        var variableKey = ifMatch.group(1);

        var isNegative = false;
        if (variableKey.startsWith("!")) {
          variableKey = variableKey.substring(1);
          isNegative = true;
        }

        final variable = variableMap.boolVariable.firstWhere(
          (item) => item.key == variableKey,
          orElse: () =>
              throw VariableNotFound(variableKey, dependencyFile.path, index),
        );

        var enable = variable.value;
        if (isNegative) {
          enable = !enable;
        }

        int endLine;
        int startLine = index + 1;
        if (endLines.isNotEmpty) {
          endLine = endLines.last;
          endLines.removeLast();
        } else {
          endLine = startLine;
        }
        for (int i = startLine; i <= endLine; i++) {
          lines[i] = mask.setLineEnable(lines[i], enable);
        }
      } else {
        final endIfMatch = mask.endIf.firstMatch(line);
        if (endIfMatch != null) {
          endLines.add(index - 1);
        }
      }
    }

    await deleteIfExist(dependencyFile);
    await dependencyFile.create();
    for (var line in lines) {
      await dependencyFile.writeAsString("$line\n", mode: FileMode.append);
    }
  }
}

abstract class _FlagMask {
  RegExp get startIf;

  RegExp get endIf;

  String setLineEnable(String line, bool enable);
}

class _DartFlagMask extends _FlagMask {
  @override
  final RegExp endIf = RegExp("[\\t\\f ]*\\/\\/\\/* *end *: *if[\\t\\f ]*");

  @override
  final RegExp startIf =
      RegExp("[\\t\\f ]*\\/\\/\\/* *if *: *(!?\\w*)[\\t\\f ]*");

  String setLineEnable(String line, bool enable) {
    final match = RegExp("([\\t\\f ]*)[\\D\\d]").firstMatch(line);
    if (match == null) {
      return line;
    }
    final space = match.group(1);
    final code = line.substring(match.end - 1);
    final isEnable = !code.startsWith("//");

    if (isEnable == enable) {
      return line;
    }

    if (enable) {
      final match = RegExp("\\/*").firstMatch(code);
      return space + code.substring(match.end);
    } else {
      return "//" + line;
    }
  }
}

class _YamlFlagMask extends _FlagMask {
  @override
  final RegExp endIf = RegExp("[\\t\\f ]*#+ *end *: *if");

  @override
  final RegExp startIf = RegExp("[\\t\\f ]*#+ *if *: *(!?\\w*)");

  String setLineEnable(String line, bool enable) {
    final match = RegExp("([\\t\\f ]*)[\\D\\d]").firstMatch(line);
    if (match == null) {
      return line;
    }
    final space = match.group(1);
    final code = line.substring(match.end - 1);
    final isEnable = !code.startsWith("#");

    if (isEnable == enable) {
      return line;
    }

    if (enable) {
      final match = RegExp("#+").firstMatch(code);
      return space + code.substring(match.end);
    } else {
      return "#" + line;
    }
  }
}
