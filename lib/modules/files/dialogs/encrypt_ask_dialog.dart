import 'package:aurorafiles/generated/s_of_context.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class EncryptAskDialog extends StatefulWidget {
  final String fileName;

  const EncryptAskDialog(this.fileName);

  @override
  State<StatefulWidget> createState() {
    return _EncryptAskDialogState();
  }
}

class _EncryptAskDialogState extends State<EncryptAskDialog> {
  @override
  Widget build(BuildContext context) {
    final s = Str.of(context);
    return AlertDialog(
      content: Text(s.hint_upload_encrypt_ask(widget.fileName)),
      actions: <Widget>[
        FlatButton(
          child: Text(s.encrypt),
          onPressed: () {
            Navigator.pop(context, true);
          },
        ),
        FlatButton(
          child: Text(s.btn_do_not_encrypt),
          onPressed: () {
            Navigator.pop(context, false);
          },
        ),
        FlatButton(
          child: Text(s.cancel),
          onPressed: () {
            Navigator.pop(context);
          },
        )
      ],
    );
  }
}
