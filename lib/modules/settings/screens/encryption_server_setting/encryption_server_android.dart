import 'package:aurora_ui_kit/aurora_ui_kit.dart';
import 'package:aurorafiles/l10n/l10n.dart';
import 'package:aurorafiles/modules/app_store.dart';
import 'package:aurorafiles/modules/settings/repository/setting_api.dart';
import 'package:aurorafiles/modules/settings/screens/encryption/dialogs/add_key_dialog.dart';
import 'package:aurorafiles/modules/settings/screens/encryption/dialogs/delete_key_confirmation_dialog.dart';
import 'package:aurorafiles/modules/settings/screens/encryption/dialogs/export_key_dialog.dart';
import 'package:aurorafiles/modules/settings/state/settings_state.dart';
import 'package:aurorafiles/override_platform.dart';
import 'package:aurorafiles/shared_ui/aurora_snack_bar.dart';
import 'package:aurorafiles/shared_ui/layout_config.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EncryptionServer extends StatefulWidget {
  const EncryptionServer({super.key});

  @override
  _EncryptionServerState createState() => _EncryptionServerState();
}

class _EncryptionServerState extends State<EncryptionServer> {
  final _settingsState = AppStore.settingsState;
  final _filesState = AppStore.filesState;
  bool showBackwardCompatibility = false;
  bool progress = false;
  bool isInit = true;
  bool encryptionExist = false;
  bool? encryptionEnable;
  bool? encryptionInPersonalStorage;
  EncryptionSetting? encryptionSetting;
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _updateEncryptionSettings();
  }

  @override
  Widget build(BuildContext context) {
    final s = context.l10n;
    final isTablet = LayoutConfig.of(context).isTablet;
    return Provider<SettingsState>(
      create: (_) => _settingsState,
      child: Scaffold(
        key: scaffoldKey,
        appBar: isTablet ? null : AMAppBar(title: Text(s.encryption)),
        body: isInit
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : !encryptionExist
                ? Center(
                    child: Text(
                      s.label_encryption_module_not_exist,
                      textAlign: TextAlign.center,
                    ),
                  )
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
                        onChanged: (bool? value) {
                          setState(() {
                            encryptionEnable = value;
                          });
                        },
                      ),
                      CheckboxListTile(
                        value: encryptionInPersonalStorage,
                        title: Text(s.btn_encryption_personal_storage),
                        onChanged: encryptionEnable ?? false
                            ? (value) {
                                setState(() {
                                  encryptionInPersonalStorage = value;
                                });
                              }
                            : null,
                      ),
                      const SizedBox(height: 48),
                      AMButton(
                        isLoading: progress,
                        onPressed: progress ? null : () => _onSave(context),
                        child: Text(s.label_save),
                      ),
                      const SizedBox(height: 20),
                      if (!showBackwardCompatibility &&
                          (encryptionEnable ?? false))
                        AMButton(
                          child: Text(s.btn_enable_backward_compatibility),
                          onPressed: () =>
                              setState(() => showBackwardCompatibility = true),
                        ),
                      if (showBackwardCompatibility &&
                          (encryptionEnable ?? false)) ...[
                        Text(s.hint_backward_compatibility_aes_key),
                        ..._buildAddingKey(),
                        ..._buildKeyOptions(),
                      ]
                    ],
                  ),
      ),
    );
  }

  Future<void> _updateEncryptionSettings() async {
    await AppStore.settingsState.updateEncryptionSettings();
    final settings = await _settingsState.getEncryptionSetting();
    encryptionExist = settings.exist;
    encryptionEnable = settings.enable;
    encryptionInPersonalStorage = settings.enableInPersonalStorage;
    isInit = false;
    if (mounted) {
      setState(() {});
    }
  }

  void _onSave(BuildContext context) async {
    _setProgress(true);
    try {
      await _settingsState.setEncryptionSetting(
        EncryptionSetting(
          exist: encryptionExist,
          enable: encryptionEnable ?? false,
          enableInPersonalStorage: encryptionInPersonalStorage ?? false,
        ),
      );
      _refreshStorages();
      if (!mounted) return;
      Navigator.pop(context);
    } catch (err) {
      _setProgress(false);
      AuroraSnackBar.showSnack(msg: '$err');
    }
  }

  void _setProgress(bool value) {
    setState(() {
      progress = value;
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
    final s = context.l10n;
    String? exportedDir;
    exportedDir = await AMDialog.show(
      context: context,
      builder: (_) => ExportKeyDialog(
        settingsState: _settingsState,
      ),
    );
    if (exportedDir != null) {
      if (!mounted) return;
      AuroraSnackBar.showSnack(
        msg: s.key_downloaded_into(exportedDir),
        isError: false,
        duration: const Duration(minutes: 10),
        action: SnackBarAction(
          label: s.oK,
          onPressed: () => AuroraSnackBar.hideSnack(),
        ),
      );
    }
  }

  List<Widget> _buildAddingKey() {
    final s = context.l10n;
    const spacer = SizedBox(height: 10.0);
    if (_settingsState.isParanoidEncryptionEnabled &&
        _settingsState.selectedKeyName == null) {
      return [
        Text(s.encryption_keys),
        const SizedBox(height: 32.0),
        Text(
          s.need_to_set_encryption_key,
          style: Theme.of(context).textTheme.caption,
        ),
        const SizedBox(height: 32.0),
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
            onSuccess: () => AuroraSnackBar.showSnack(
              msg: s.import_encryption_key_success,
              isError: false,
            ),
            onError: (_) =>
                AuroraSnackBar.showSnack(msg: s.key_not_found_in_file),
          ),
        ),
        spacer,
      ];
    } else {
      return [];
    }
  }

  List<Widget> _buildKeyOptions() {
    final s = context.l10n;
    const spacer = SizedBox(height: 10.0);
    final theme = Theme.of(context);
    if (_settingsState.selectedKeyName != null) {
      return [
        const SizedBox(height: 26.0),
        Text(s.encryption_keys),
        spacer,
        Text(
          _settingsState.selectedKeyName ?? '',
          style: Theme.of(context).textTheme.subtitle1,
        ),
        const Divider(height: 32.0),
        Text(
          s.encryption_export_description,
          style: Theme.of(context).textTheme.caption,
        ),
        const SizedBox(height: 32.0),
        AMButton(onPressed: _shareKey, child: Text(s.share_key)),
        if (!PlatformOverride.isIOS) spacer,
        if (!PlatformOverride.isIOS)
          AMButton(onPressed: _downloadKey, child: Text(s.download_key)),
        spacer,
        AMButton(
          color: theme.errorColor,
          shadow: const BoxShadow(
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
              if (!mounted) return;
              AuroraSnackBar.showSnack(
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
