import 'dart:io';

import 'package:aurorafiles/generated/s_of_context.dart';
import 'package:aurorafiles/modules/settings/state/settings_state.dart';
import 'package:aurorafiles/utils/show_snack.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ExportKeyDialog extends StatefulWidget {
  final SettingsState settingsState;
  final ScaffoldState scaffoldState;

  const ExportKeyDialog(
      {Key key, @required this.settingsState, @required this.scaffoldState})
      : super(key: key);

  @override
  _ExportKeyDialogState createState() => _ExportKeyDialogState();
}

class _ExportKeyDialogState extends State<ExportKeyDialog> {
  bool _isExporting = false;

  @override
  Widget build(BuildContext context) {
    final s = Str.of(context);
    if (Platform.isIOS) {
      return CupertinoAlertDialog(
        title: Text(widget.settingsState.selectedKeyName),
        content: _isExporting
            ? Row(
          children: <Widget>[
            CupertinoActivityIndicator(),
            SizedBox(width: 20.0),
            Text(s.export_key_progress)
          ],
        )
            : Text(s.export_confirm),
        actions: <Widget>[
          CupertinoButton(
              child: Text(s.cancel), onPressed: Navigator
              .of(context)
              .pop),
          CupertinoButton(
            child: Text(s.export),
            onPressed: _isExporting
                ? null
                : () {
              setState(() => _isExporting = true);
              widget.settingsState.onExportEncryptionKey(
                onSuccess: (String exportedDir) =>
                    Navigator.pop(context, exportedDir),
                onError: (String err) {
                  Navigator.pop(context);
                  showSnack(
                      context: context,
                      scaffoldState: widget.scaffoldState,
                      msg: err);
                },
              );
            },
          )
        ],
      );
    } else {
      return AlertDialog(
        title: Text(widget.settingsState.selectedKeyName),
        content: _isExporting
            ? Row(
          children: <Widget>[
            CircularProgressIndicator(),
            SizedBox(width: 20.0),
            Text(s.export_key_progress)
          ],
        )
            : Text(s.export_confirm),
        actions: <Widget>[
          FlatButton(
              child: Text(s.cancel.toUpperCase()), onPressed: Navigator
              .of(context)
              .pop),
          FlatButton(
            child: Text(s.export.toUpperCase()),
            onPressed: _isExporting
                ? null
                : () {
              setState(() => _isExporting = true);
              widget.settingsState.onExportEncryptionKey(
                onSuccess: (String exportedDir) =>
                    Navigator.pop(context, exportedDir),
                onError: (String err) {
                  Navigator.pop(context);
                  showSnack(
                      context: context,
                      scaffoldState: widget.scaffoldState,
                      msg: err);
                },
              );
            },
          )
        ],
      );
    }
  }
}
