import 'package:aurora_ui_kit/aurora_ui_kit.dart';
import 'package:aurorafiles/generated/s_of_context.dart';
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
      TextButton(
        child: Text(s.cancel),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
      TextButton(
        child: Text(s.delete),
        onPressed: () {
          Navigator.pop(context, true);
        },
      )
    ];
    return AMDialog(content: content, actions: actions);
  }
}
