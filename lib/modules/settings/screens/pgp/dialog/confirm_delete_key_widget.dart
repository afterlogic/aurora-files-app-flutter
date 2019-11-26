import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ConfirmDeleteKeyWidget extends StatefulWidget {
  final String _message;

  const ConfirmDeleteKeyWidget(this._message);

  @override
  _ConfirmDeleteKeyWidgetState createState() => _ConfirmDeleteKeyWidgetState();
}

class _ConfirmDeleteKeyWidgetState extends State<ConfirmDeleteKeyWidget> {
  @override
  Widget build(BuildContext context) {
    final content = Text(widget._message);
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
