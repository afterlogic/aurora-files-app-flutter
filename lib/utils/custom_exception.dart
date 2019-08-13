import 'package:flutter/widgets.dart';

class CustomException implements Exception {
  final String message;

  CustomException({@required this.message}) : super();

  @override
  String toString() => message;
}