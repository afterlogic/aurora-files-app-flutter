import 'package:aurora_ui_kit/aurora_ui_kit.dart';
import 'package:aurorafiles/generated/s_of_context.dart';
import 'package:aurorafiles/modules/app_store.dart';
import 'package:aurorafiles/modules/settings/repository/setting_api.dart';
import 'package:aurorafiles/modules/settings/screens/encryption/dialogs/add_key_dialog.dart';
import 'package:aurorafiles/modules/settings/screens/encryption/dialogs/delete_key_confirmation_dialog.dart';
import 'package:aurorafiles/modules/settings/screens/encryption/dialogs/export_key_dialog.dart';
import 'package:aurorafiles/modules/settings/state/settings_state.dart';
import 'package:aurorafiles/override_platform.dart';
import 'package:aurorafiles/shared_ui/layout_config.dart';
import 'package:aurorafiles/utils/show_snack.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EncryptionServer extends StatefulWidget {
  @override
  _EncryptionServerState createState() => _EncryptionServerState();
}

class _EncryptionServerState extends State<EncryptionServer> {
  final _settingsState = AppStore.settingsState;
  final _filesState = AppStore.filesState;
  bool showBackwardCompatibility = false;
  S s;
  bool progress = false;
  bool encryptionEnable;
  bool encryptionInPersonalStorage;
  EncryptionSetting encryptionSetting;
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _settingsState.getEncryptionSetting().then((value) {
      setState(() {
        encryptionSetting = value;
        encryptionEnable = value.enable;
        encryptionInPersonalStorage = value.enableInPersonalStorage;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    s = Str.of(context);
    final isTablet = LayoutConfig.of(context).isTablet;
    return Provider<SettingsState>(
      create: (_) => _settingsState,
      child: Scaffold(
        key: scaffoldKey,
        appBar: isTablet ? null : AMAppBar(title: Text(s.encryption)),
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
                    value: encryptionEnable,
                    title: Text(s.btn_encryption_enable),
                    onChanged: (bool value) {
                      setState(() {
                        encryptionEnable = value;
                      });
                    },
                  ),
                  CheckboxListTile(
                    value: encryptionInPersonalStorage,
                    title: Text(s.btn_encryption_personal_storage),
                    onChanged: (bool value) {
                      setState(() {
                        encryptionInPersonalStorage = value;
                      });
                    },
                  ),
                  SizedBox(height: 48),
                  AMButton(
                    isLoading: progress,
                    child: Text(s.btn_encryption_save),
                    onPressed: progress ? null : save,
                  ),
                  SizedBox(height: 20),
                  if (!showBackwardCompatibility)
                    AMButton(
                      child: Text(s.btn_enable_backward_compatibility),
                      onPressed: () =>
                          setState(() => showBackwardCompatibility = true),
                    ),
                  if (showBackwardCompatibility) ...[
                    Text(s.hint_backward_compatibility_aes_key),
                    ..._buildAddingKey(),
                    ..._buildKeyOptions(),
                  ]
                ],
              ),
      ),
    );
  }

  save() async {
    setState(() {
      progress = true;
    });
    _settingsState
        .setEncryptionSetting(
      EncryptionSetting(
        encryptionEnable,
        encryptionInPersonalStorage,
      ),
    )
        .then((_) {
      _refreshStorages();
      Navigator.pop(context);
    }).catchError((e) {
      setState(() {
        progress = false;
      });
      showSnack(context, msg: e.toString());
    });
  }

  Future<void> _refreshStorages() async {
    final currentStorageName = _filesState.selectedStorage.displayName;
    await _filesState.onGetStorages();
    final index = _filesState.currentStorages
        .indexWhere((e) => e.displayName == currentStorageName);
    if (index != -1) {
      _filesState.selectedStorage = _filesState.currentStorages[index];
    }
  }

  void _shareKey() async {
    _settingsState.onShareEncryptionKey(
      Rect.fromCenter(
        center: MediaQuery.of(context).size.bottomCenter(Offset.zero),
        width: 0,
        height: 0,
      ),
    );
  }

  void _downloadKey() async {
    var exportedDir;
    exportedDir = await AMDialog.show(
      context: context,
      builder: (_) => ExportKeyDialog(
        settingsState: _settingsState,
        scaffoldState: scaffoldKey.currentState,
      ),
    );
    if (exportedDir is String) {
      showSnack(context,
          msg: s.key_downloaded_into(exportedDir),
          isError: false,
          duration: Duration(minutes: 10),
          action: SnackBarAction(
            label: s.oK,
            onPressed: () => hideSnack(context),
          ));
    }
  }

  List<Widget> _buildAddingKey() {
    final spacer = const SizedBox(height: 10.0);
    if (_settingsState.isParanoidEncryptionEnabled &&
        _settingsState.selectedKeyName == null) {
      return [
        Text(s.encryption_keys),
        SizedBox(height: 32.0),
        Text(
          s.need_to_set_encryption_key,
          style: Theme.of(context).textTheme.caption,
        ),
        SizedBox(height: 32.0),
        AMButton(
          child: Text(s.import_key_from_text),
          onPressed: () => AMDialog.show(
            context: context,
            builder: (_) => AddKeyDialog(
              settingsState: _settingsState,
              isImport: true,
            ),
          ),
        ),
        spacer,
        AMButton(
          child: Text(s.import_key_from_file),
          onPressed: () => _settingsState.onImportKeyFromFile(
            onSuccess: () => showSnack(
              context,
              msg: s.import_encryption_key_success,
              isError: false,
            ),
            onError: (err) => showSnack(context, msg: s.key_not_found_in_file),
          ),
        ),
        spacer,
      ];
    } else {
      return [];
    }
  }

  List<Widget> _buildKeyOptions() {
    final spacer = const SizedBox(height: 10.0);
    final theme = Theme.of(context);
    if (_settingsState.selectedKeyName != null) {
      return [
        SizedBox(height: 26.0),
        Text(s.encryption_keys),
        spacer,
        Text(
          _settingsState.selectedKeyName,
          style: Theme.of(context).textTheme.subhead,
        ),
        Divider(height: 32.0),
        Text(
          s.encryption_export_description,
          style: Theme.of(context).textTheme.caption,
        ),
        SizedBox(height: 32.0),
        AMButton(child: Text(s.share_key), onPressed: _shareKey),
        if (!PlatformOverride.isIOS) spacer,
        if (!PlatformOverride.isIOS)
          AMButton(child: Text(s.download_key), onPressed: _downloadKey),
        spacer,
        AMButton(
          color: theme.errorColor,
          shadow: BoxShadow(
            color: Colors.black26,
            blurRadius: 8.0,
            offset: Offset(0.0, 3.0),
          ),
          child: Text(s.delete_key),
          onPressed: () async {
            final result = await AMDialog.show(
              context: context,
              builder: (_) => DeleteKeyConfirmationDialog(
                settingsState: _settingsState,
              ),
            );
            if (result == DeleteKeyConfirmationDialogResult.delete) {
              showSnack(
                context,
                msg: s.delete_encryption_key_success,
                isError: false,
              );
              setState(() {});
            } else if (result == DeleteKeyConfirmationDialogResult.export) {
              _downloadKey();
            }
          },
        ),
      ];
    } else {
      return [];
    }
  }
}
