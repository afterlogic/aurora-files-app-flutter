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
      title: Text(s.label_required_pgp_key),
      content: Text(s.hint_upload_encrypt_ask(widget.fileName)),
      actions: <Widget>[
        FlatButton(
          child: Text(s.oK),
          onPressed: () {
            Navigator.pop(context, true);
          },
        )
      ],
    );
  }
}
