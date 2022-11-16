import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'app_color.dart';

class AppTheme {
  static final ThemeData? login = null;

  static final Color? loginTextColor = null;

  static TextStyle subtitle1NewTextStyle(bool isDark) => TextStyle(
        color: isDark ? AppColorDark.subtext : AppColorLight.subtext,
        fontSize: 12.0,
        fontWeight: FontWeight.w400,
      );

  static final light = ThemeData(
    colorScheme: ColorScheme(
      brightness: Brightness.light,
      primary: AppColorLight.primary,
      onPrimary: AppColorLight.onPrimary,
      secondary: AppColorLight.secondary,
      onSecondary: AppColorLight.onSecondary,
      background: AppColorLight.background,
      onBackground: AppColorLight.onBackground,
      surface: AppColorLight.surface,
      onSurface: AppColorLight.onSurface,
      error: AppColorLight.error,
      onError: AppColorLight.onError,
    ),
    primaryColor: AppColorLight.primary,
    buttonTheme: _buttonThemeLight,
    dialogTheme: _dialogTheme,
    splashFactory: InkRipple.splashFactory,
    brightness: Brightness.light,
    disabledColor: AppColorLight.onBackground.withOpacity(0.4),
    scaffoldBackgroundColor: AppColorLight.background,
    toggleableActiveColor: AppColorLight.secondary,
    textTheme: _textThemeLight,
    appBarTheme: _appBarThemeLight,
    floatingActionButtonTheme: _floatThemeLight,
    cardTheme: _cardTheme,
    textSelectionTheme: _textSelectionThemeLight,
    dividerColor: AppColorLight.divider,
    iconTheme: _iconThemeLight,
  );

  static final dark = ThemeData(
    colorScheme: ColorScheme(
      brightness: Brightness.dark,
      primary: AppColorDark.primary,
      onPrimary: AppColorDark.onPrimary,
      secondary: AppColorDark.secondary,
      onSecondary: AppColorDark.onSecondary,
      background: AppColorDark.background,
      onBackground: AppColorDark.onBackground,
      surface: AppColorDark.surface,
      onSurface: AppColorDark.onSurface,
      error: AppColorDark.error,
      onError: AppColorDark.onError,
    ),
    primaryColor: AppColorDark.primary,
    buttonTheme: _buttonThemeDark,
    dialogTheme: _dialogTheme,
    splashFactory: InkRipple.splashFactory,
    brightness: Brightness.dark,
    disabledColor: AppColorDark.onBackground.withOpacity(0.4),
    scaffoldBackgroundColor: AppColorDark.background,
    toggleableActiveColor: AppColorDark.secondary,
    textTheme: _textThemeDark,
    appBarTheme: _appBarThemeDark,
    floatingActionButtonTheme: _floatThemeDark,
    cardTheme: _cardTheme,
    bottomAppBarColor: Colors.black,
    textSelectionTheme: _textSelectionThemeDark,
    dividerColor: AppColorDark.divider,
    iconTheme: _iconThemeDark,
  );

  static final _dialogTheme = DialogTheme(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
  );

  static const _buttonThemeLight = ButtonThemeData(
    buttonColor: AppColorLight.secondary,
    textTheme: ButtonTextTheme.primary,
  );

  static const _buttonThemeDark = ButtonThemeData(
    buttonColor: AppColorDark.secondary,
    textTheme: ButtonTextTheme.primary,
  );

  static final _floatThemeLight = FloatingActionButtonThemeData(
    hoverColor: AppColorLight.secondary.withOpacity(0.8),
    backgroundColor: AppColorLight.secondary,
  );

  static final _floatThemeDark = FloatingActionButtonThemeData(
    hoverColor: AppColorDark.secondary.withOpacity(0.8),
    backgroundColor: AppColorDark.secondary,
  );

  static const _cardTheme = CardTheme(
    elevation: 0,
  );

  static const _iconThemeLight = IconThemeData(
    color: AppColorLight.onBackground,
  );

  static const _iconThemeDark = IconThemeData(
    color: AppColorDark.onBackground,
  );

  static const _textSelectionThemeLight = TextSelectionThemeData(
    cursorColor: AppColorLight.secondary,
    selectionColor: AppColorLight.secondary,
    selectionHandleColor: AppColorLight.secondary,
  );

  static const _textSelectionThemeDark = TextSelectionThemeData(
    cursorColor: AppColorDark.secondary,
    selectionColor: AppColorDark.secondary,
    selectionHandleColor: AppColorDark.secondary,
  );

  static const _textThemeLight = TextTheme(
    headline4: TextStyle(
      color: AppColorLight.onBackground,
      fontSize: 32.0,
      fontWeight: FontWeight.w500,
    ),
  );

  static const _textThemeDark = TextTheme(
    headline4: TextStyle(
      color: AppColorDark.onBackground,
      fontSize: 32.0,
      fontWeight: FontWeight.w500,
    ),
  );

  static const _appBarThemeLight = AppBarTheme(
    systemOverlayStyle: SystemUiOverlayStyle(
      statusBarBrightness: Brightness.light,
    ),
    color: AppColorLight.background,
    iconTheme: _iconThemeLight,
    actionsIconTheme: _iconThemeLight,
    titleTextStyle: TextStyle(
      color: AppColorLight.onBackground,
      fontSize: 18.0,
      fontWeight: FontWeight.w500,
    ),
    toolbarTextStyle: TextStyle(
      color: AppColorLight.onBackground,
      fontSize: 12.0,
      fontWeight: FontWeight.w400,
    ),
  );

  static const _appBarThemeDark = AppBarTheme(
    systemOverlayStyle: SystemUiOverlayStyle(
      statusBarBrightness: Brightness.dark,
    ),
    color: AppColorDark.background,
    iconTheme: _iconThemeDark,
    actionsIconTheme: _iconThemeDark,
    titleTextStyle: TextStyle(
      color: AppColorDark.onBackground,
      fontSize: 18.0,
      fontWeight: FontWeight.w500,
    ),
    toolbarTextStyle: TextStyle(
      color: AppColorDark.onBackground,
      fontSize: 12.0,
      fontWeight: FontWeight.w400,
    ),
  );
}
