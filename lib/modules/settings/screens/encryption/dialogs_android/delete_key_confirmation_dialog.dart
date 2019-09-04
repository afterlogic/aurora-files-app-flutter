import 'package:aurorafiles/modules/settings/screens/encryption/dialogs_android/export_key_dialog.dart';
import 'package:flutter/material.dart';

class DeleteKeyConfirmationDialog extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    return AlertDialog(
      title: Text("Delete key"),
      content: Text(
          "Attention! You'll no longer be able to decrypt encrypted files on this device unless you import this key again."),
      actions: <Widget>[
        FlatButton(
          child: Text("CANCEL"),
          onPressed: () => Navigator.pop(context),
        ),
        FlatButton(
          child: Text("EXPORT"),
          onPressed: () {
            Navigator.pop(context);
            showDialog(
                context: context,
                barrierDismissible: false,
                builder: (_) => ExportKeyDialog());
          },
        ),
        FlatButton(
          child: Text(
            "DELETE",
            style: TextStyle(color: Theme.of(context).errorColor),
          ),
          onPressed: () {},
        ),
      ],
    );
  }
}
