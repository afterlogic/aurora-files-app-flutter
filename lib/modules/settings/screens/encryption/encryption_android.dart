import 'dart:io';

import 'package:aurorafiles/generated/i18n.dart';
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
  S s;
  void _exportKey() async {
    var exportedDir;
    if (Platform.isIOS) {
      exportedDir =  await showCupertinoDialog(
          context: context,
          builder: (_) => ExportKeyDialog(
                settingsState: _settingsState,
                scaffoldState: _scaffoldKey.currentState,
              ));
    } else {
      exportedDir = await showDialog(
          context: context,
          builder: (_) => ExportKeyDialog(
                settingsState: _settingsState,
                scaffoldState: _scaffoldKey.currentState,
              ));
    }
    if (exportedDir is String) {
      showSnack(
          context: context,
          scaffoldState: _scaffoldKey.currentState,
          msg: s.key_exported_into(exportedDir),
          isError: false,
          duration: Duration(minutes: 10),
          action: SnackBarAction(
            label: s.oK,
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
          child: Text(s.encryption_keys),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Text(
            s.need_to_set_encryption_key,
            style: Theme.of(context).textTheme.caption,
          ),
        ),
        SizedBox(height: 8.0),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 2.0),
          child: AppButton(
            text: s.import_key_from_text,
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
            text: s.import_key_from_file,
            onPressed: () => _settingsState.onImportKeyFromFile(
                onSuccess: () => showSnack(
                    context: context,
                    scaffoldState: _scaffoldKey.currentState,
                    isError: false,
                    msg: s.import_encryption_key_success),
                onError: (err) => showSnack(
                      context: context,
                      scaffoldState: _scaffoldKey.currentState,
                  msg: s.key_not_found_in_file,
                    )),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 2.0),
          child: AppButton(
            text: s.generate_key,
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
          child: Text(s.encryption_keys),
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
            s.encryption_export_description,
            style: Theme.of(context).textTheme.caption,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 2.0),
          child: AppButton(text: s.export_key, onPressed: _exportKey),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 2.0),
          child: AppButton(
            buttonColor: !Platform.isIOS ? Theme.of(context).errorColor : null,
            textColor: Platform.isIOS ? Theme.of(context).errorColor : null,
            text: s.delete_key,
            onPressed: () async {
              final result = await showDialog(
                  context: context,
                  builder: (_) => DeleteKeyConfirmationDialog(
                      settingsState: _settingsState));
              if (result == DeleteKeyConfirmationDialogResult.delete) {
                showSnack(
                  context: context,
                  scaffoldState: _scaffoldKey.currentState,
                  msg: s.delete_encryption_key_success,
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
    s = S.of(context);
    return Provider<SettingsState>(
      create: (_) => _settingsState,
      child: Observer(
        builder: (_) => Scaffold(
          key: _scaffoldKey,
          appBar: AppBar(
            title: Text(s.encryption),
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
                  s.encryption_description,
                  style: Theme
                      .of(context)
                      .textTheme
                      .caption,
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
