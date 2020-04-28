import 'package:aurora_ui_kit/aurora_ui_kit.dart';
import 'package:aurora_ui_kit/aurora_ui_kit.dart';
import 'package:aurorafiles/generated/s_of_context.dart';
import 'package:aurorafiles/modules/app_store.dart';
import 'package:aurorafiles/modules/settings/repository/setting_api.dart';
import 'package:aurorafiles/modules/settings/screens/encryption/dialogs/add_key_dialog.dart';
import 'package:aurorafiles/modules/settings/screens/encryption/dialogs/delete_key_confirmation_dialog.dart';
import 'package:aurorafiles/modules/settings/screens/encryption/dialogs/export_key_dialog.dart';
import 'package:aurorafiles/modules/settings/state/settings_state.dart';
import 'package:aurorafiles/override_platform.dart';
import 'package:aurorafiles/utils/show_snack.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';

class EncryptionServer extends StatefulWidget {
  @override
  _EncryptionServerState createState() => _EncryptionServerState();
}

class _EncryptionServerState extends State<EncryptionServer> {
  final _settingsState = AppStore.settingsState;
  S s;
  bool progress = false;
  UploadEncryptMode uploadEncryptMode;
  bool enable;
  EncryptionSetting encryptionSetting;
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    _settingsState.getEncryptionSetting().then((value) {
      encryptionSetting = value;
      uploadEncryptMode = value.uploadEncryptMode;
      enable = value.enable;
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    s = Str.of(context);
    return Provider<SettingsState>(
      create: (_) => _settingsState,
      child: Scaffold(
        key: scaffoldKey,
        appBar: AMAppBar(title: Text(s.encryption)),
        body: encryptionSetting == null
            ? SizedBox.shrink()
            : ListView(
                padding: const EdgeInsets.all(16.0),
                children: <Widget>[
                  Text(
                    s.encryption_description,
                    style: Theme.of(context).textTheme.caption,
                  ),
                  CheckboxListTile(
                    value: enable,
                    title: Text(s.btn_encryption_enable),
                    onChanged: (bool value) {
                      enable = value;
                      setState(() {});
                    },
                  ),
                  DropdownButtonFormField(
                    decoration: InputDecoration(
                      labelText: s.label_encryption_mode,
                      alignLabelWithHint: true,
                    ),
                    value: uploadEncryptMode,
                    items: UploadEncryptMode.values.map((value) {
                      return DropdownMenuItem<UploadEncryptMode>(
                        value: value,
                        child: Text(map(value)),
                      );
                    }).toList(),
                    onChanged: (v) {
                      uploadEncryptMode = v;
                      setState(() {});
                    },
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  AMButton(
                    isLoading: progress,
                    child: Text(s.btn_encryption_save),
                    onPressed: progress ? null: save,
                  )
                ],
              ),
      ),
    );
  }

  save() async {
    progress = true;
    setState(() {});
    AppStore.settingsState
        .setEncryptionSetting(EncryptionSetting(
      uploadEncryptMode,
      enable,
    ))
        .then((_) {
      Navigator.pop(context);
    }).catchError((e) {
      progress = false;
      setState(() {});
      showSnack(
          context: context,
          scaffoldState: scaffoldKey.currentState,
          msg: e.toString());
    });
  }

  String map(UploadEncryptMode mode) {
    switch (mode) {
      case UploadEncryptMode.Always:
        return s.label_encryption_always;
      case UploadEncryptMode.Ask:
        return s.label_encryption_ask;
      case UploadEncryptMode.Never:
        return s.label_encryption_never;
      case UploadEncryptMode.InEncryptedFolder:
        return s.label_encryption_always_in_encryption_folder;
    }
    return "";
  }
}
