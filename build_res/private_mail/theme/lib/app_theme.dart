import 'dart:io';

import 'package:flutter/material.dart';

import 'app_color.dart';

class AppTheme {
  static ThemeData light = ThemeData(
    brightness: Brightness.light,
    primaryColor: AppColor.primary,
    primaryColorDark: AppColor.primaryVariant,
    primaryColorLight: Color.alphaBlend(Colors.white24, AppColor.primary),
    accentColor: AppColor.accent,
    buttonColor: Colors.black26,
    buttonTheme: _buttonTheme,
    scaffoldBackgroundColor: Colors.white,
    toggleableActiveColor: AppColor.accent,
    textSelectionHandleColor: AppColor.accent,
    snackBarTheme: SnackBarThemeData(
      backgroundColor: Color(0xFF1A1A1A),
      actionTextColor: Colors.white,
    ),
    cursorColor: AppColor.accent,
    highlightColor: Platform.isIOS ? Colors.transparent : null,
    splashColor: Platform.isIOS ? Colors.transparent : null,
    splashFactory: InkRipple.splashFactory,
    selectedRowColor: Colors.black12,
    colorScheme: colorScheme,
    floatingActionButtonTheme: _floatTheme,
    dialogTheme: _dialogTheme,
    appBarTheme: AppBarTheme(
      color: AppColor.primary,
      iconTheme: IconThemeData(
        color: Colors.white,
      ),
    ),
  );

  static ThemeData dark = ThemeData(
    floatingActionButtonTheme: _floatTheme,
    brightness: Brightness.dark,
    primaryColor: AppColor.primary,
    primaryColorDark: AppColor.primaryVariant,
    primaryColorLight: Color.alphaBlend(Colors.white24, AppColor.primary),
    accentColor: AppColor.accent,
    buttonColor: Colors.black26,
    buttonTheme: _buttonTheme,
    scaffoldBackgroundColor: Color(0xFF1A1A1A),
    toggleableActiveColor: AppColor.accent,
    textSelectionHandleColor: AppColor.accent,
    snackBarTheme: SnackBarThemeData(
      backgroundColor: Colors.white,
      actionTextColor: Colors.black,
    ),
    cursorColor: AppColor.accent,
    highlightColor: Platform.isIOS ? Colors.transparent : null,
    splashColor: Platform.isIOS ? Colors.transparent : null,
    splashFactory: InkRipple.splashFactory,
    selectedRowColor: Colors.white10,
    dialogTheme: _dialogTheme,
    appBarTheme: AppBarTheme(
      color: AppColor.primary,
      iconTheme: IconThemeData(
        color: Colors.white,
      ),
    ),
    colorScheme: colorScheme.copyWith(brightness: Brightness.dark),
  );

  static final colorScheme = ColorScheme(
    error: AppColor.warning,
    onError: AppColor.warning.withAlpha(200),
    secondary: AppColor.secondary,
    secondaryVariant: AppColor.secondaryVariant,
    onSecondary: AppColor.secondary.withAlpha(200),
    primary: AppColor.primary,
    primaryVariant: AppColor.primaryVariant,
    onPrimary: AppColor.primary.withAlpha(200),
    surface: AppColor.surface,
    onSurface: AppColor.surface.withAlpha(200),
    background: Color.alphaBlend(Colors.white70, Colors.grey),
    onBackground: Color.alphaBlend(Colors.white54, Colors.grey),
    brightness: Brightness.light,
  );

  static final _dialogTheme = DialogTheme(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
  );

  static final login = dark;
  static final _buttonTheme = ButtonThemeData(
    buttonColor: AppColor.accent,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50.0)),
    textTheme: ButtonTextTheme.primary,
  );
  static final _floatTheme = FloatingActionButtonThemeData(
    hoverColor: AppColor.accent.withOpacity(0.5),
    backgroundColor: AppColor.accent,
  );
}
