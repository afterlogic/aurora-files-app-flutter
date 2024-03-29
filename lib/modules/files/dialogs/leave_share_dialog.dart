import 'package:aurora_ui_kit/aurora_ui_kit.dart';
import 'package:aurorafiles/l10n/l10n.dart';
import 'package:flutter/material.dart';

class LeaveShareDialog extends StatelessWidget {
  final String name;
  final bool isFolder;

  const LeaveShareDialog({
    Key? key,
    required this.name,
    required this.isFolder,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final s = context.l10n;
    final textStyle = Theme.of(context).textTheme.subtitle1;
    final text = RichText(
      text: TextSpan(
        style: textStyle,
        children: [
          TextSpan(
            text: s.label_leave_share_of,
          ),
          TextSpan(
            text: name,
            style: textStyle?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          TextSpan(
            text: isFolder ? ' ${s.folder}?' : ' ${s.file}?',
          ),
        ],
      ),
    );

    return AMDialog(
      // title: Text(title),
      content: text,
      actions: <Widget>[
        TextButton(
          child: Text(s.label_leave_share),
          onPressed: () => Navigator.pop(context, true),
        ),
        TextButton(
          child: Text(s.cancel),
          onPressed: () => Navigator.pop(context, false),
        ),
      ],
    );
  }
}
