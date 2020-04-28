import 'package:aurora_ui_kit/components/dialogs/am_dialog.dart';
import 'package:aurorafiles/generated/s_of_context.dart';
import 'package:flutter/material.dart';

class KeyRequestDialog extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _KeyRequestDialogState();
  }

  static Future<String> show(BuildContext context) {
    return AMDialog.show(
      context: context,
      builder: (context) => KeyRequestDialog(),
    );
  }
}

class _KeyRequestDialogState extends State<KeyRequestDialog> {
  final passCtrl = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final s = Str.of(context);
    return AlertDialog(
      title: Text(s.label_encryption_password_for_pgp_key),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Form(
            key: formKey,
            child: TextFormField(
              validator: (v) {
                if (v.isEmpty) {
                  return s.password_is_empty;
                }
                return null;
              },
              decoration: InputDecoration(labelText: s.password),
              controller: passCtrl,
            ),
          ),
        ],
      ),
      actions: <Widget>[
        FlatButton(
          child: Text(s.oK),
          onPressed: () {
            if (formKey.currentState.validate()) {
              Navigator.pop(context, passCtrl.text);
            }
          },
        )
      ],
    );
  }
}
