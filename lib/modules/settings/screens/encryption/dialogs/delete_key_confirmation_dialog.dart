import 'package:aurora_ui_kit/aurora_ui_kit.dart';
import 'package:aurorafiles/l10n/l10n.dart';
import 'package:aurorafiles/modules/settings/state/settings_state.dart';
import 'package:flutter/material.dart';

enum DeleteKeyConfirmationDialogResult {
  cancel,
  export,
  delete,
}

class DeleteKeyConfirmationDialog extends StatelessWidget {
  final SettingsState settingsState;

  const DeleteKeyConfirmationDialog({Key? key, required this.settingsState})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final s = context.l10n;
    final title = Text(s.delete_key);
    final content = Text(s.delete_key_description);
    return AMDialog(
      title: title,
      content: content,
      actions: <Widget>[
        TextButton(
          child: Text(s.cancel),
          onPressed: () =>
              Navigator.pop(context, DeleteKeyConfirmationDialogResult.cancel),
        ),
        TextButton(
          child: Text(s.download),
          onPressed: () {
            Navigator.pop(context, DeleteKeyConfirmationDialogResult.export);
          },
        ),
        TextButton(
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
  }
}
