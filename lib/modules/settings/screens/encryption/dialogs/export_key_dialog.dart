import 'package:aurora_ui_kit/aurora_ui_kit.dart';
import 'package:aurorafiles/l10n/l10n.dart';
import 'package:aurorafiles/modules/settings/state/settings_state.dart';
import 'package:aurorafiles/shared_ui/aurora_snack_bar.dart';
import 'package:flutter/material.dart';

class ExportKeyDialog extends StatefulWidget {
  final SettingsState settingsState;

  const ExportKeyDialog({Key? key, required this.settingsState})
      : super(key: key);

  @override
  _ExportKeyDialogState createState() => _ExportKeyDialogState();
}

class _ExportKeyDialogState extends State<ExportKeyDialog> {
  bool _isExporting = false;

  @override
  Widget build(BuildContext context) {
    final s = context.l10n;
    return AMDialog(
      title: Text(widget.settingsState.selectedKeyName ?? ''),
      content: _isExporting
          ? Row(
              children: <Widget>[
                const CircularProgressIndicator(),
                const SizedBox(width: 20.0),
                Text(s.download_key_progress)
              ],
            )
          : Text(s.download_confirm),
      actions: <Widget>[
        TextButton(onPressed: Navigator.of(context).pop, child: Text(s.cancel)),
        TextButton(
          onPressed: _isExporting
              ? null
              : () {
                  setState(() => _isExporting = true);
                  widget.settingsState.onExportEncryptionKey(
                    onSuccess: (String? exportedDir) =>
                        Navigator.pop(context, exportedDir),
                    onError: (String err) {
                      Navigator.pop(context);
                      AuroraSnackBar.showSnack(msg: err);
                    },
                  );
                },
          child: Text(s.download),
        )
      ],
    );
  }
}
