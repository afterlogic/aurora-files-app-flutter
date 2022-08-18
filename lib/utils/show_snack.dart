import 'package:flutter/material.dart';

void showSnack(
  BuildContext context, {
  @required String msg,
  Duration duration = const Duration(seconds: 5),
  SnackBarAction action,
  isError = true,
}) {
  final scaffoldMessenger = ScaffoldMessenger.of(context);
  if (Theme == null || scaffoldMessenger == null) return;
  if (isError) {
    print(msg);
  }
  final theme = Theme.of(context);
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

void hideSnack(BuildContext context) {
  ScaffoldMessenger.of(context).clearSnackBars();
}
