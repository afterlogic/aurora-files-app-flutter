import 'package:flutter/material.dart';

void showSnack({
  @required BuildContext context,
  @required ScaffoldState scaffoldState,
  @required String msg,
  isError = true,
}) {
  final snack = SnackBar(
    content: Text(msg),
    backgroundColor: isError ? Theme.of(context).errorColor : null,
  );

  if (scaffoldState != null) {
    scaffoldState.removeCurrentSnackBar();
  }
  scaffoldState.showSnackBar(snack);
}
