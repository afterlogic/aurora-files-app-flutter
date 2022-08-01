import 'package:flutter/material.dart';
import 'app_color.dart';

class AppTheme {
  static final light = ThemeData(
    primaryColor: AppColor.primary,
    accentColor: AppColor.accent,
    buttonColor: AppColor.accent,
    buttonTheme: _buttonTheme,
    dialogTheme: _dialogTheme,
    splashFactory: InkRipple.splashFactory,
    brightness: Brightness.light,
    disabledColor: Colors.black.withOpacity(0.4),
    scaffoldBackgroundColor: Colors.white,
    toggleableActiveColor: AppColor.accent,
    textTheme: TextTheme(
      headline4: TextStyle(
        color: Colors.black,
        fontSize: 32.0,
        fontWeight: FontWeight.w500,
      ),
    ),
    appBarTheme: AppBarTheme(
      brightness: Brightness.light,
      color: Colors.white,
      iconTheme: IconThemeData(color: Colors.black),
      actionsIconTheme: IconThemeData(color: Colors.black),
      textTheme: TextTheme(
        headline6: TextStyle(
          color: Colors.black,
          fontSize: 18.0,
          fontWeight: FontWeight.w500,
        ),
        subtitle2: TextStyle(
          color: Colors.black,
          fontSize: 12.0,
          fontWeight: FontWeight.w400,
        ),
      ),
    ),
    floatingActionButtonTheme: _floatTheme,
    cardTheme: _cardTheme,
    textSelectionTheme: _textSelectionTheme,
  );

  static final dark = ThemeData(
    primaryColor: AppColor.primary,
    accentColor: AppColor.accent,
    buttonColor: AppColor.accent,
    buttonTheme: _buttonTheme,
    dialogTheme: _dialogTheme,
    splashFactory: InkRipple.splashFactory,
    brightness: Brightness.dark,
    disabledColor: Colors.white.withOpacity(0.4),
    scaffoldBackgroundColor: Color(0xFF1A1A1A),
    toggleableActiveColor: AppColor.accent,
    textTheme: TextTheme(
      headline4: TextStyle(
        color: Colors.white,
        fontSize: 32.0,
        fontWeight: FontWeight.w500,
      ),
    ),
    appBarTheme: AppBarTheme(
      brightness: Brightness.dark,
      color: Colors.black,
      iconTheme: IconThemeData(color: Colors.white),
      actionsIconTheme: IconThemeData(color: Colors.white),
      textTheme: TextTheme(
        headline6: TextStyle(
          color: Colors.white,
          fontSize: 18.0,
          fontWeight: FontWeight.w500,
        ),
        subtitle2: TextStyle(
          color: Colors.white,
          fontSize: 12.0,
          fontWeight: FontWeight.w400,
        ),
      ),
    ),
    floatingActionButtonTheme: _floatTheme,
    cardTheme: _cardTheme,
    bottomAppBarColor: Colors.black,
    textSelectionTheme: _textSelectionTheme,
  );

  static final ThemeData login = null;

  static Color loginTextColor;

  static final _dialogTheme = DialogTheme(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
  );

  static final _buttonTheme = ButtonThemeData(
    buttonColor: AppColor.accent,
    textTheme: ButtonTextTheme.primary,
  );

  static final _floatTheme = FloatingActionButtonThemeData(
    hoverColor: AppColor.accent.withOpacity(0.8),
    backgroundColor: AppColor.accent,
  );

  static final floatIconTheme = IconThemeData(
    color: Colors.white,
  );

  static final _cardTheme = CardTheme(
    elevation: 0,
  );

  static final _textSelectionTheme = TextSelectionThemeData(
    cursorColor: AppColor.accent,
    selectionColor: AppColor.accent,
    selectionHandleColor: AppColor.accent,
  );
}
