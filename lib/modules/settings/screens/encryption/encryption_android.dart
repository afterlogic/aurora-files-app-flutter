import 'package:aurorafiles/modules/app_store.dart';
import 'package:aurorafiles/modules/settings/screens/encryption/dialogs_android/add_key_dialog.dart';
import 'package:aurorafiles/modules/settings/screens/encryption/dialogs_android/delete_key_confirmation_dialog.dart';
import 'package:aurorafiles/modules/settings/screens/encryption/dialogs_android/export_key_dialog.dart';
import 'package:aurorafiles/modules/settings/state/settings_state.dart';
import 'package:aurorafiles/shared_ui/app_button.dart';
import 'package:aurorafiles/utils/show_snack.dart';
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
    final exportedDir = await showDialog(
        context: context,
        builder: (_) => ExportKeyDialog(settingsState: _settingsState));
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
            child: Text("IMPORT KEY FROM TEXT"),
            onPressed: () => showDialog(
              context: context,
              barrierDismissible: false,
              builder: (_) =>
                  AddKeyDialog(settingsState: _settingsState, isImport: true),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 2.0),
          child: AppButton(
            child: Text("IMPORT KEY FROM FILE"),
            onPressed: () => _settingsState.onImportKeyFromFile(
                onError: (err) => showSnack(
                      context: context,
                      scaffoldState: _scaffoldKey.currentState,
                      msg: err,
                    )),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 2.0),
          child: AppButton(
            child: Text("GENERATE KEYS"),
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
          child: AppButton(child: Text("EXPORT KEY"), onPressed: _exportKey),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 2.0),
          child: AppButton(
            color: Theme.of(context).errorColor,
            child: Text("DELETE KEY"),
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
              SwitchListTile(
                value: _settingsState.isParanoidEncryptionEnabled,
                onChanged: (bool v) =>
                    _settingsState.isParanoidEncryptionEnabled = v,
                title: Text("Enable Paranoid Encryption"),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: Divider(height: 0),
              ),
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
