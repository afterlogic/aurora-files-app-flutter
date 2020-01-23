import 'dart:io';

import 'package:aurorafiles/generated/s_of_context.dart';
import 'package:aurorafiles/modules/settings/state/settings_state.dart';
import 'package:flutter/cupertino.dart';
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
    final s = Str.of(context);
    final title = Text(s.delete_key);
    final content = Text(s.delete_key_description);
    if (Platform.isIOS) {
      return CupertinoAlertDialog(
        title: title,
        content: content,
        actions: <Widget>[
          CupertinoButton(
            child: Text(s.cancel),
            onPressed: () => Navigator.pop(
                context, DeleteKeyConfirmationDialogResult.cancel),
          ),
          CupertinoButton(
            child: Text(s.download),
            onPressed: () {
              Navigator.pop(context, DeleteKeyConfirmationDialogResult.export);
            },
          ),
          CupertinoButton(
            child: Text(
              s.delete,
              style: TextStyle(color: Theme.of(context).errorColor),
            ),
            onPressed: () async {
              await settingsState.onDeleteEncryptionKey();
              await settingsState.getUserEncryptionKeys();
              Navigator.pop(context, DeleteKeyConfirmationDialogResult.delete);
            },
          ),
        ],
      );
    } else {
      return AlertDialog(
        title: title,
        content: content,
        actions: <Widget>[
          FlatButton(
            child: Text(s.cancel.toUpperCase()),
            onPressed: () => Navigator.pop(
                context, DeleteKeyConfirmationDialogResult.cancel),
          ),
          FlatButton(
            child: Text(s.download.toUpperCase()),
            onPressed: () {
              Navigator.pop(context, DeleteKeyConfirmationDialogResult.export);
            },
          ),
          FlatButton(
            child: Text(
              s.delete.toUpperCase(),
              style: TextStyle(color: Theme.of(context).errorColor),
            ),
            onPressed: () async {
              await settingsState.onDeleteEncryptionKey();
              await settingsState.getUserEncryptionKeys();
              Navigator.pop(context, DeleteKeyConfirmationDialogResult.delete);
            },
          ),
        ],
      );
    }
  }
}
