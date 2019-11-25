import 'dart:io';

import 'package:aurorafiles/database/app_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ConfirmDeleteKeyWidget extends StatefulWidget {
  final LocalPgpKey _pgpKey;

  const ConfirmDeleteKeyWidget(this._pgpKey);

  @override
  _ConfirmDeleteKeyWidgetState createState() => _ConfirmDeleteKeyWidgetState();
}

class _ConfirmDeleteKeyWidgetState extends State<ConfirmDeleteKeyWidget> {
  @override
  Widget build(BuildContext context) {
    final content = Text(
        "Are you sure you want to delete OpenPGP key for ${widget._pgpKey.email}?");
    final actions = <Widget>[
      FlatButton(
        child: Text("Cancel"),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
      FlatButton(
        child: Text("Delete"),
        onPressed: () {
          Navigator.pop(context, true);
        },
      )
    ];
    return Platform.isIOS
        ? CupertinoAlertDialog(content: content, actions: actions)
        : AlertDialog(content: content, actions: actions);
  }
}
