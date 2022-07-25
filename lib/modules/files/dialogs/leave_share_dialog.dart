import 'package:aurora_ui_kit/aurora_ui_kit.dart';
import 'package:aurorafiles/generated/s_of_context.dart';
import 'package:flutter/material.dart';

class LeaveShareDialog extends StatelessWidget {
  final String name;
  final bool isFolder;

  const LeaveShareDialog({
    Key key,
    @required this.name,
    @required this.isFolder,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final s = Str.of(context);
    final textStyle = Theme.of(context).textTheme.subtitle1;
    final text = RichText(
      text: TextSpan(
        style: textStyle,
        children: [
          TextSpan(
            text: 'Leave share of the ',
          ),
          TextSpan(
            text: name,
            style: textStyle.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          TextSpan(
            text: isFolder ? ' folder?' : ' file?',
          ),
        ],
      ),
    );

    return AMDialog(
      // title: Text(title),
      content: text,
      actions: <Widget>[
        TextButton(
          child: Text('Leave share'),
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
