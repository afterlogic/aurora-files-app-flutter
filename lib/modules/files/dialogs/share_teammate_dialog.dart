
import 'package:aurora_ui_kit/components/dialogs/am_dialog.dart';
import 'package:aurorafiles/generated/s_of_context.dart';
import 'package:flutter/material.dart';

class ShareTeammateDialog extends StatefulWidget {
  const ShareTeammateDialog({Key key}) : super(key: key);

  @override
  State<ShareTeammateDialog> createState() => _ShareTeammateDialogState();
}

class _ShareTeammateDialogState extends State<ShareTeammateDialog> {
  @override
  Widget build(BuildContext context) {
    final s = Str.of(context);
    return AMDialog(
      title: Text(s.label_share_with_teammates),
      content: SizedBox(
        width: double.infinity,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text('Some text'),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          child: Text(s.cancel),
          onPressed: () => Navigator.pop(context),
        ),
      ],
    );
  }
}
