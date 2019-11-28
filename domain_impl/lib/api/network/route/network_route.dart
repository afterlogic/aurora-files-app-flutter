import 'dart:convert';

import 'package:domain_impl/api/network/util/map_util.dart';

abstract class NetworkRoute {
  String get module;

  final String method;
  final bool toUpperCase;

  Map<String, dynamic> get parameters;

  Map<String, dynamic> toJson() {
    if (parameters != null) {
      return {
        'Module': module,
        'Method': method,
        'Parameters': json.encode(
          toUpperCase == true ? keysToUpperCase(parameters) : parameters,
        ),
      };
    } else {
      return {
        'Module': module,
        'Method': method,
      };
    }
  }

  NetworkRoute(Object method, this.toUpperCase)
      : method = _describeEnum(method);

  static String _describeEnum(Object enumEntry) {
    final String description = enumEntry.toString();
    final int indexOfDot = description.indexOf('.');
    assert(indexOfDot != -1 && indexOfDot < description.length - 1);
    return description.substring(indexOfDot + 1);
  }
}
