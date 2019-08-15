import 'package:flutter/cupertino.dart';

class ApiBody {
  final String module;
  final String method;
  final String parameters;

  ApiBody({
    @required this.module,
    @required this.method,
    @required this.parameters,
  });

  Map<String, String> toMap() {
    return {
      'Module': module,
      'Method': method,
      'Parameters': parameters
    };
  }
}
