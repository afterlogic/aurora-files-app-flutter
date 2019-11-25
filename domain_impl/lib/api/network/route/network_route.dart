import 'dart:convert';

abstract class NetworkRoute {
  String get module;

  String method;

  Map<String, dynamic> get parameters;

  Map<String, dynamic> toJson() {
    if (parameters != null) {
      return {
        'Module': module,
        'Method': method,
        'Parameters': json.encode(parameters),
      };
    } else {
      return {
        'Module': module,
        'Method': method,
      };
    }
  }

  NetworkRoute(Object method) : method = _describeEnum(method);
}

//method from flutter/foundation.dart
String _describeEnum(Object enumEntry) {
  final String description = enumEntry.toString();
  final int indexOfDot = description.indexOf('.');
  assert(indexOfDot != -1 && indexOfDot < description.length - 1);
  return description.substring(indexOfDot + 1);
}
