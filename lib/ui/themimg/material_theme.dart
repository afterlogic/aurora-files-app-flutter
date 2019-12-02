import 'dart:io';

import 'package:flutter/material.dart';

class AppMaterialTheme {
  static final commonTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: Color(0xFF6b0b3f),
    primaryColorDark: Color(0xFF3d0826),
    accentColor: Color(0xFFbc4799),
    primaryColorLight: Colors.purple[200],
    toggleableActiveColor: Color(0xFFbc4799),
    textSelectionHandleColor: Color(0xFFbc4799),
    selectedRowColor: Color(0x11660041),
    highlightColor: Platform.isIOS ? Colors.transparent : null,
    splashColor: Platform.isIOS ? Colors.transparent : null,
    splashFactory: InkRipple.splashFactory,
    inputDecorationTheme: _inputTheme,
    buttonTheme: _buttonTheme,
  );

  static final darkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: Color(0xFF6b0b3f),
    primaryColorDark: Color(0xFF3d0826),
    accentColor: Color(0xFFbc4799),
    primaryColorLight: Colors.purple[200],
    toggleableActiveColor: Color(0xFFbc4799),
    textSelectionHandleColor: Colors.purple[200],
    selectedRowColor: Color(0x11660041),
    highlightColor: Platform.isIOS ? Colors.transparent : null,
    splashColor: Platform.isIOS ? Colors.transparent : null,
    splashFactory: InkRipple.splashFactory,
    inputDecorationTheme: _inputTheme,
    buttonTheme: _buttonTheme,
  );

  static final _inputTheme = InputDecorationTheme(
//    border: OutlineInputBorder(borderRadius: BorderRadius.zero),
  );

  static final _buttonTheme = ButtonThemeData(
    buttonColor: Color(0xFFbc4799),
    shape: RoundedRectangleBorder( borderRadius: BorderRadius.circular(50.0)),
    textTheme: ButtonTextTheme.primary,
  );
}
