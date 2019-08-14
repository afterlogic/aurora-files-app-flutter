import 'package:flutter/material.dart';

class AppMaterialTheme {
  static final theme = ThemeData(
    brightness: Brightness.light,
    primaryColor: Color(0xFF004166),
    accentColor: Color(0xFF72bbe4),
    errorColor: Colors.red[900],
    selectedRowColor: Color(0x11004166),
    inputDecorationTheme: _inputTheme,
    buttonTheme: _buttonTheme,
  );

  static final darkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: Colors.pink,
    accentColor: Colors.blue,
    errorColor: Colors.red[900],
    inputDecorationTheme: _inputTheme,
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

