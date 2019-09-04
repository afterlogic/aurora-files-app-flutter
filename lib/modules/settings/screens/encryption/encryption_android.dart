import 'package:aurorafiles/modules/app_store.dart';
import 'package:aurorafiles/modules/settings/screens/encryption/dialogs_android/delete_key_confirmation_dialog.dart';
import 'package:aurorafiles/modules/settings/screens/encryption/dialogs_android/export_key_dialog.dart';
import 'package:aurorafiles/modules/settings/screens/encryption/dialogs_android/generate_key_dialog.dart';
import 'package:aurorafiles/modules/settings/screens/encryption/dialogs_android/import_key_dialog.dart';
import 'package:aurorafiles/modules/settings/state/settings_state.dart';
import 'package:aurorafiles/shared_ui/app_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';

class EncryptionAndroid extends StatefulWidget {
  @override
  _EncryptionAndroidState createState() => _EncryptionAndroidState();
}

class _EncryptionAndroidState extends State<EncryptionAndroid> {
  final _settingsState = AppStore.settingsState;

  List<Widget> _buildAddingKey() {
    if (_settingsState.isParanoidEncryptionEnabled &&
        _settingsState.encryptionKey == null) {
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
            onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => ImportKeyDialog(), fullscreenDialog: true)),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 2.0),
          child: AppButton(
            child: Text("IMPORT KEY FROM FILE"),
            onPressed: () {},
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 2.0),
          child: AppButton(
            child: Text("GENERATE KEYS"),
            onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => GenerateKeyDialog(),
                    fullscreenDialog: true)),
          ),
        ),
      ];
    } else {
      return [];
    }
  }

  List<Widget> _buildKeyOptions() {
    if (_settingsState.encryptionKey != null) {
      return [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
          child: Text("Encryption key:"),
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
          child: AppButton(
            child: Text("EXPORT KEY"),
            onPressed: () => showDialog(
                context: context,
                barrierDismissible: false,
                builder: (_) => ExportKeyDialog()),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 2.0),
          child: AppButton(
            color: Theme.of(context).errorColor,
            child: Text("DELETE KEY"),
            onPressed: () => showDialog(
                context: context,
                builder: (_) => DeleteKeyConfirmationDialog()),
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
              Divider(height: 0),
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
