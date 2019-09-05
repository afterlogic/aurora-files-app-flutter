import 'package:aurorafiles/modules/settings/state/settings_state.dart';
import 'package:flutter/material.dart';

class ExportKeyDialog extends StatefulWidget {
  final SettingsState settingsState;

  const ExportKeyDialog({Key key, @required this.settingsState})
      : super(key: key);

  @override
  _ExportKeyDialogState createState() => _ExportKeyDialogState();
}

class _ExportKeyDialogState extends State<ExportKeyDialog> {
  bool _isExporting = false;
  String errMsg = "";

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.settingsState.selectedKeyName),
      content: _isExporting
          ? Row(
              children: <Widget>[
                CircularProgressIndicator(),
                SizedBox(width: 20.0),
                Text("Exporting the key...")
              ],
            )
          : Text("Are you sure you want to export this key?"),
      actions: <Widget>[
        FlatButton(child: Text("CANCEL"), onPressed: Navigator.of(context).pop),
        FlatButton(
          child: Text("EXPORT"),
          onPressed: _isExporting
              ? null
              : () {
                  errMsg = "";
                  setState(() => _isExporting = true);
                  widget.settingsState.onExportEncryptionKey(
                    onSuccess: (String exportedDir) =>
                        Navigator.pop(context, exportedDir),
                    onError: (String err) => setState(() => errMsg = err),
                  );
                },
        )
      ],
    );
  }
}
