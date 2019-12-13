import 'dart:io';

import 'package:aurorafiles/generated/i18n.dart';
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
    final s = S.of(context);
    final content = Text(widget._message);
    final actions = <Widget>[
      FlatButton(
        child: Text(s.cancel),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
      FlatButton(
        child: Text(s.delete),
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
