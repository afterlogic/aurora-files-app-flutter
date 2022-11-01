import 'package:aurora_ui_kit/aurora_ui_kit.dart';
import 'package:aurorafiles/l10n/l10n.dart';
import 'package:flutter/material.dart';

class ErrorDialog extends StatelessWidget {
  final String title;
  final String message;

  const ErrorDialog(this.title, this.message, {super.key});

  @override
  Widget build(BuildContext context) {
    final s = context.l10n;
    final title = Text(this.title);
    final content = Text(message);
    final action = [
      TextButton(
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
