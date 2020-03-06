import 'dart:io';

import 'package:aurora_ui_kit/aurora_ui_kit.dart';
import 'package:aurorafiles/generated/s_of_context.dart';
import 'package:aurorafiles/override_platform.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ErrorDialog extends StatelessWidget {
  final String title;
  final String message;

  const ErrorDialog(this.title, this.message);

  @override
  Widget build(BuildContext context) {
    final s = Str.of(context);
    final title = Text(this.title);
    final content = Text(message);
    final action = [
      FlatButton(
        child: Text(s.cancel),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
    ];

    return AMDialog(
      title: title,
      content: content,
      actions: action,
    );
  }
}
