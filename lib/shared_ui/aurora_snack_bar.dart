import 'package:aurorafiles/modules/settings/state/settings_state.dart';
import 'package:flutter/material.dart';
import 'package:theme/app_theme.dart';

class AuroraSnackBar {
  static late GlobalKey<ScaffoldMessengerState> _scaffoldMessengerKey;
  static late SettingsState _settingsState;

  static void init({
    required GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey,
    required SettingsState settingsState,
  }) {
    _scaffoldMessengerKey = scaffoldMessengerKey;
    _settingsState = settingsState;
  }

  static void showSnack({
    required String msg,
    Duration duration = const Duration(seconds: 5),
    SnackBarAction? action,
    isError = true,
  }) {
    final scaffoldMessenger = _scaffoldMessengerKey.currentState;
    if (scaffoldMessenger == null) {
      return;
    }

    final theme =
        _settingsState.isDarkTheme == true ? AppTheme.dark : AppTheme.light;
    final backgroundColor = isError ? theme.colorScheme.error : null;
    final textColor = isError ? theme.colorScheme.onError : null;
    final snack = SnackBar(
      duration: duration,
      content: Text(
        msg,
        style: TextStyle(color: textColor),
      ),
      backgroundColor: backgroundColor,
      action: action,
    );

    scaffoldMessenger.clearSnackBars();
    scaffoldMessenger.showSnackBar(snack);
  }

  static void hideSnack() {
    _scaffoldMessengerKey.currentState?.clearSnackBars();
  }
}
