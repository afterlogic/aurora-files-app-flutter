import 'package:aurorafiles/modules/settings/state/settings_state.dart';
import 'package:flutter/material.dart';

enum DeleteKeyConfirmationDialogResult {
  cancel,
  export,
  delete,
}

class DeleteKeyConfirmationDialog extends StatelessWidget {
  final SettingsState settingsState;

  const DeleteKeyConfirmationDialog({Key key, @required this.settingsState})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Delete key"),
      content: Text(
          "Attention! You'll no longer be able to decrypt encrypted files on this device unless you import this key again."),
      actions: <Widget>[
        FlatButton(
          child: Text("CANCEL"),
          onPressed: () =>
              Navigator.pop(context, DeleteKeyConfirmationDialogResult.export),
        ),
        FlatButton(
          child: Text("EXPORT"),
          onPressed: () {
            Navigator.pop(context, DeleteKeyConfirmationDialogResult.export);
          },
        ),
        FlatButton(
          child: Text(
            "DELETE",
            style: TextStyle(color: Theme.of(context).errorColor),
          ),
          onPressed: () async {
            await settingsState.onDeleteEncryptionKey();
            await settingsState.getUserEncryptionKeys();
            Navigator.pop(context,  DeleteKeyConfirmationDialogResult.delete);
          },
        ),
      ],
    );
  }
}
