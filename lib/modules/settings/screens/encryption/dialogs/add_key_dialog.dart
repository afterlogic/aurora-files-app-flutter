import 'dart:io';

import 'package:aurorafiles/generated/s_of_context.dart';
import 'package:aurorafiles/modules/app_store.dart';
import 'package:aurorafiles/modules/settings/state/settings_state.dart';
import 'package:aurorafiles/override_platform.dart';
import 'package:aurorafiles/shared_ui/ios/alert_input_ios.dart';
import 'package:aurorafiles/utils/input_validation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AddKeyDialog extends StatefulWidget {
  final SettingsState settingsState;
  final bool isImport;

  const AddKeyDialog({
    Key key,
    this.isImport = false,
    @required this.settingsState,
  }) : super(key: key);

  @override
  _AddKeyDialogState createState() => _AddKeyDialogState();
}

class _AddKeyDialogState extends State<AddKeyDialog> {
  final _keyCtrl = TextEditingController();
  final _nameCtrl = TextEditingController();
  final _addKeyFormKey = GlobalKey<FormState>();
  bool _isAdding = false;
  String errMsg = "";

  @override
  void initState() {
    super.initState();
    _nameCtrl.text = AppStore.authState.userEmail;
  }

  @override
  Widget build(BuildContext context) {
    final s = Str.of(context);
    if (PlatformOverride.isIOS) {
      return CupertinoAlertDialog(
        title: Text(widget.isImport ? s.import_key : s.generate_key),
        content: _isAdding
            ? Row(
          children: <Widget>[
            CupertinoActivityIndicator(),
            SizedBox(width: 20.0),
            Text(s.add_key_progress)
          ],
        )
            : Form(
          key: _addKeyFormKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              SizedBox(height: 10.0),
              AlertInputIos(
                controller: _nameCtrl,
                autofocus: true,
                icon: Icons.title,
                placeholder: s.key_name,

              ),
              if (widget.isImport) SizedBox(height: 8.0),
              if (widget.isImport)
                AlertInputIos(
                  controller: _keyCtrl,
                  icon: Icons.vpn_key,
                  placeholder: s.key_text,
                ),
            ],
          ),
        ),
        actions: <Widget>[
          CupertinoButton(
            child: Text(s.cancel),
            onPressed: () => Navigator.pop(context),
          ),
          CupertinoButton(
              child: Text(widget.isImport ? s.import : s.generate),
              onPressed: _isAdding
                  ? null
                  : () async {
                if (!_addKeyFormKey.currentState.validate()) return;
                errMsg = "";
                setState(() => _isAdding = true);
                await widget.settingsState.onAddKey(
                  name: _nameCtrl.text,
                  encryptionKey: widget.isImport ? _keyCtrl.text : null,
                  onError: (String err) {
                    errMsg = err;
                    setState(() => _isAdding = false);
                  },
                );
                await widget.settingsState.getUserEncryptionKeys();
                Navigator.pop(context, true);
              }),
        ],
      );
    } else {
      return AlertDialog(
        title: Text(widget.isImport ? s.import_key : s.generate_key),
        content: _isAdding
            ? Row(
          children: <Widget>[
            CircularProgressIndicator(),
            SizedBox(width: 20.0),
            Text(s.add_key_progress)
          ],
        )
            : Form(
          key: _addKeyFormKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextFormField(
                controller: _nameCtrl,
                autofocus: true,
                decoration: InputDecoration(
                  isDense: true,
                  icon: Icon(Icons.title),
                  hintText: s.key_name,
                  border: UnderlineInputBorder(),
                ),
                validator: (value) =>
                    validateInput(
                      value,
                      [ValidationTypes.empty, ValidationTypes.uniqueName],
                      widget.settingsState.encryptionKeys.keys.toList(),
                    ),
              ),
              if (widget.isImport) SizedBox(height: 8.0),
              if (widget.isImport)
                TextFormField(
                  controller: _keyCtrl,
                  decoration: InputDecoration(
                    isDense: true,
                    icon: Icon(Icons.vpn_key),
                    hintText: s.key_text,
                    border: UnderlineInputBorder(),
                  ),
                  validator: (value) =>
                      validateInput(
                        value,
                        [ValidationTypes.empty],
                      ),
                ),
            ],
          ),
        ),
        actions: <Widget>[
          FlatButton(
            child: Text(s.cancel.toUpperCase()),
            onPressed: () => Navigator.pop(context),
          ),
          FlatButton(
              child: Text(widget.isImport ? s.import.toUpperCase() : s.generate
                  .toUpperCase()),
              onPressed: _isAdding
                  ? null
                  : () async {
                if (!_addKeyFormKey.currentState.validate()) return;
                errMsg = "";
                setState(() => _isAdding = true);
                await widget.settingsState.onAddKey(
                  name: _nameCtrl.text,
                  encryptionKey: widget.isImport ? _keyCtrl.text : null,
                  onError: (String err) {
                    errMsg = err;
                    setState(() => _isAdding = false);
                  },
                );
                await widget.settingsState.getUserEncryptionKeys();
                Navigator.pop(context, true);
              }),
        ],
      );
    }
  }
}
