import 'package:flutter/material.dart';

class AuroraSnackBar {
  static late GlobalKey<ScaffoldMessengerState> _scaffoldMessengerKey;

  static void init(GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey) {
    _scaffoldMessengerKey = scaffoldMessengerKey;
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

    final theme = Theme.of(scaffoldMessenger.context);
    final textColor = !isError ? theme.scaffoldBackgroundColor : Colors.white;
    final backgroundColor = isError ? theme.errorColor : null;
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
