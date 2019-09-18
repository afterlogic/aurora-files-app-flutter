import 'dart:io';

import 'package:aurorafiles/modules/app_store.dart';
import 'package:aurorafiles/modules/settings/screens/encryption/dialogs/add_key_dialog.dart';
import 'package:aurorafiles/modules/settings/screens/encryption/dialogs/delete_key_confirmation_dialog.dart';
import 'package:aurorafiles/modules/settings/screens/encryption/dialogs/export_key_dialog.dart';
import 'package:aurorafiles/modules/settings/state/settings_state.dart';
import 'package:aurorafiles/shared_ui/app_button.dart';
import 'package:aurorafiles/utils/show_snack.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';

class EncryptionAndroid extends StatefulWidget {
  @override
  _EncryptionAndroidState createState() => _EncryptionAndroidState();
}

class _EncryptionAndroidState extends State<EncryptionAndroid> {
  final _settingsState = AppStore.settingsState;
  final _scaffoldKey = new GlobalKey<ScaffoldState>();

  void _exportKey() async {
    var exportedDir;
    if (Platform.isIOS) {
      await showCupertinoDialog(
          context: context,
          builder: (_) => ExportKeyDialog(settingsState: _settingsState));
    } else {
      exportedDir = await showDialog(
          context: context,
          builder: (_) => ExportKeyDialog(settingsState: _settingsState));
    }
    if (exportedDir is String) {
      showSnack(
          context: context,
          scaffoldState: _scaffoldKey.currentState,
          msg: "The key was exported into: $exportedDir",
          isError: false,
          duration: Duration(minutes: 10),
          action: SnackBarAction(
            label: "OK",
            onPressed: _scaffoldKey.currentState.hideCurrentSnackBar,
          ));
    }
  }

  List<Widget> _buildAddingKey() {
    if (_settingsState.isParanoidEncryptionEnabled &&
        _settingsState.selectedKeyName == null) {
      return [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
          child: Text("Encryption key:"),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Text(
            "To start using encryption of uploaded files your need to set any encryption key.",
            style: Theme.of(context).textTheme.caption,
          ),
        ),
        SizedBox(height: 8.0),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 2.0),
          child: AppButton(
            text: "Import key from text",
            onPressed: () => Platform.isIOS
                ? showCupertinoDialog(
                    context: context,
                    builder: (_) => AddKeyDialog(
                        settingsState: _settingsState, isImport: true),
                  )
                : showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (_) => AddKeyDialog(
                        settingsState: _settingsState, isImport: true),
                  ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 2.0),
          child: AppButton(
            text: "Import key from file",
            onPressed: () => _settingsState.onImportKeyFromFile(
                onError: (err) => showSnack(
                      context: context,
                      scaffoldState: _scaffoldKey.currentState,
                      msg: "Could not find a key in this file",
                    )),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 2.0),
          child: AppButton(
            text: "Generate keys",
            onPressed: () => showDialog(
              context: context,
              barrierDismissible: false,
              builder: (_) => AddKeyDialog(settingsState: _settingsState),
            ),
          ),
        ),
      ];
    } else {
      return [];
    }
  }

  List<Widget> _buildKeyOptions() {
    if (_settingsState.selectedKeyName != null) {
      return [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
          child: Text("Encryption key:"),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Text(
            _settingsState.selectedKeyName,
            style: Theme.of(context).textTheme.subhead,
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          child: Divider(),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Text(
            "To access encrypted files on other devices/browsers, export the key and then import it on another device/browser.",
            style: Theme.of(context).textTheme.caption,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 2.0),
          child: AppButton(text: "Export key", onPressed: _exportKey),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 2.0),
          child: AppButton(
            buttonColor: !Platform.isIOS ? Theme.of(context).errorColor : null,
            textColor: Platform.isIOS ? Theme.of(context).errorColor : null,
            text: "Delete key",
            onPressed: () async {
              final result = await showDialog(
                  context: context,
                  builder: (_) => DeleteKeyConfirmationDialog(
                      settingsState: _settingsState));
              if (result == DeleteKeyConfirmationDialogResult.delete) {
                showSnack(
                  context: context,
                  scaffoldState: _scaffoldKey.currentState,
                  msg: "The encryption key was successfully deleted",
                  isError: false,
                );
              } else if (result == DeleteKeyConfirmationDialogResult.export) {
                _exportKey();
              }
            },
          ),
        ),
      ];
    } else {
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Provider<SettingsState>(
      builder: (_) => _settingsState,
      child: Observer(
        builder: (_) => Scaffold(
          key: _scaffoldKey,
          appBar: AppBar(
            title: Text("Encryption"),
          ),
          body: ListView(
            children: <Widget>[
//              SwitchListTile.adaptive(
//                value: _settingsState.isParanoidEncryptionEnabled,
//                activeColor: Theme.of(context).accentColor,
//                onChanged: (bool v) {
//                  _settingsState.isParanoidEncryptionEnabled = v;
//                  final filesState = AppStore.filesState;
//                  if (filesState.selectedStorage.type == "encrypted") {
//                    filesState.selectedStorage =
//                        filesState.currentStorages[0];
//                        filesState.updateFilesCb();
//                  }
//                },
//                title: Text("Enable Paranoid Encryption"),
//              ),
//              Padding(
//                padding: EdgeInsets.symmetric(horizontal: 16.0),
//                child: Divider(height: 0),
//              ),
              Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  "Files are encrypted/decrypted right on this device, even the server itself cannot get access to non-encrypted content of paranoid-encrypted files. Encryption method is AES256.",
                  style: Theme.of(context).textTheme.caption,
                ),
              ),
              ..._buildAddingKey(),
              ..._buildKeyOptions(),
            ],
          ),
        ),
      ),
    );
  }
}
