import 'package:yaml/yaml.dart';

class VariableMap {
  final List<Variable<bool>> boolVariable = [];
  final List<Variable<num>> numVariable = [];
  final List<Variable<String>> stringVariable = [];
  final List<Variable<List>> listVariable = [];
  final List<Variable<dynamic>> otherVariable = [];

  VariableMap();

  add(String key, value) {
    if (value is bool) {
      boolVariable.add(Variable(key, value));
    } else if (value is num) {
      numVariable.add(Variable(key, value));
    } else if (value is String) {
      stringVariable.add(Variable(key, value));
    } else if (value is List) {
      listVariable.add(Variable(key, value));
    } else {
      otherVariable.add(Variable(key, value));
    }
  }

  List<Variable> getPublic() {
    final outList = <Variable>[];

    outList.addAll(boolVariable.where((item) => item.isPublic));
    outList.addAll(numVariable.where((item) => item.isPublic));
    outList.addAll(stringVariable.where((item) => item.isPublic));
    outList.addAll(otherVariable.where((item) => item.isPublic));

    return outList;
  }

  static VariableMap fromMap(YamlMap map) {
    final variableMap = VariableMap();
    map.forEach((key, value) {
      variableMap.add(key, value);
    });
    return variableMap;
  }
}

class Variable<T> {
  final bool isPublic;
  final T value;
  final String key;

  Variable(String key, T value)
      : value = value,
        key = key,
        isPublic = !key.startsWith("_");

  String get valueString =>
      value is num || value is bool ? "$value" : "\"$value\"";
}
