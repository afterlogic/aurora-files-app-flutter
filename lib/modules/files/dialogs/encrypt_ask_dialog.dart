import 'package:aurorafiles/l10n/l10n.dart';
import 'package:flutter/material.dart';

class EncryptAskDialog extends StatefulWidget {
  final String fileName;

  const EncryptAskDialog(this.fileName, {super.key});

  @override
  State<StatefulWidget> createState() {
    return _EncryptAskDialogState();
  }
}

class _EncryptAskDialogState extends State<EncryptAskDialog> {
  @override
  Widget build(BuildContext context) {
    final s = context.l10n;
    return AlertDialog(
      content: Text(s.hint_upload_encrypt_ask(widget.fileName)),
      actions: <Widget>[
        TextButton(
          child: Text(s.encrypt),
          onPressed: () {
            Navigator.pop(context, true);
          },
        ),
        TextButton(
          child: Text(s.btn_do_not_encrypt),
          onPressed: () {
            Navigator.pop(context, false);
          },
        ),
        TextButton(
          child: Text(s.cancel),
          onPressed: () {
            Navigator.pop(context);
          },
        )
      ],
    );
  }
}
