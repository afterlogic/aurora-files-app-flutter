import 'dart:io';

import 'package:aurorafiles/generated/s_of_context.dart';
import 'package:aurorafiles/override_platform.dart';
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
    final s = Str.of(context);
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
    return PlatformOverride.isIOS
        ? CupertinoAlertDialog(content: content, actions: actions)
        : AlertDialog(content: content, actions: actions);
  }
}
