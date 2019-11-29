import 'package:flutter/material.dart';

class AppCupertinoTheme {
  static final theme = ThemeData(
    brightness: Brightness.light,
    primaryColor: Color(0xFF004166),
    accentColor: Color(0xFF72bbe4),
    errorColor: Colors.red[900],
    inputDecorationTheme: _inputTheme,
    highlightColor: Colors.transparent,
    splashColor: Colors.transparent,
    buttonTheme: _buttonTheme,
  );

  static final _inputTheme = InputDecorationTheme(
    border: OutlineInputBorder(borderRadius: BorderRadius.zero),
  );

  static final _buttonTheme = ButtonThemeData(
    shape: RoundedRectangleBorder( borderRadius: BorderRadius.circular(50.0)),
    textTheme: ButtonTextTheme.primary,
  );
}

