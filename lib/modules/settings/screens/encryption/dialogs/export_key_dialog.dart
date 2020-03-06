import 'dart:io';

import 'package:aurora_ui_kit/aurora_ui_kit.dart';
import 'package:aurorafiles/generated/s_of_context.dart';
import 'package:aurorafiles/modules/settings/state/settings_state.dart';
import 'package:aurorafiles/override_platform.dart';
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
    return AMDialog(
      title: Text(widget.settingsState.selectedKeyName),
      content: _isExporting
          ? Row(
              children: <Widget>[
                CircularProgressIndicator(),
                SizedBox(width: 20.0),
                Text(s.download_key_progress)
              ],
            )
          : Text(s.download_confirm),
      actions: <Widget>[
        FlatButton(child: Text(s.cancel), onPressed: Navigator.of(context).pop),
        FlatButton(
          child: Text(s.download),
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
