import 'package:aurora_ui_kit/aurora_ui_kit.dart';
import 'package:aurorafiles/l10n/l10n.dart';
import 'package:aurorafiles/modules/app_store.dart';
import 'package:aurorafiles/modules/settings/screens/encryption/dialogs/add_key_dialog.dart';
import 'package:aurorafiles/modules/settings/screens/encryption/dialogs/delete_key_confirmation_dialog.dart';
import 'package:aurorafiles/modules/settings/screens/encryption/dialogs/export_key_dialog.dart';
import 'package:aurorafiles/modules/settings/state/settings_state.dart';
import 'package:aurorafiles/override_platform.dart';
import 'package:aurorafiles/shared_ui/aurora_snack_bar.dart';
import 'package:aurorafiles/shared_ui/layout_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';

class EncryptionAndroid extends StatefulWidget {
  const EncryptionAndroid({super.key});

  @override
  _EncryptionAndroidState createState() => _EncryptionAndroidState();
}

class _EncryptionAndroidState extends State<EncryptionAndroid> {
  final _settingsState = AppStore.settingsState;
  final _scaffoldKey = GlobalKey<ScaffoldState>();

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
            onError: (err) =>
                AuroraSnackBar.showSnack(msg: s.key_not_found_in_file),
          ),
        ),
        spacer,
        AMButton(
          child: Text(s.generate_key),
          onPressed: () => AMDialog.show(
            context: context,
            builder: (_) => AddKeyDialog(settingsState: _settingsState),
          ),
        ),
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
              AuroraSnackBar.showSnack(
                msg: s.delete_encryption_key_success,
                isError: false,
              );
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

  @override
  Widget build(BuildContext context) {
    final s = context.l10n;
    final isTablet = LayoutConfig.of(context).isTablet;
    return Provider<SettingsState>(
      create: (_) => _settingsState,
      child: Observer(
        builder: (_) => Scaffold(
          key: _scaffoldKey,
          appBar: isTablet ? null : AMAppBar(title: Text(s.encryption)),
          body: ListView(
            padding: const EdgeInsets.all(16.0),
            children: <Widget>[
//              SwitchListTile.adaptive(
//                value: _settingsState.isParanoidEncryptionEnabled,
//                activeColor: Theme.of(context).primaryColor,
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
              Text(
                s.encryption_description,
                style: Theme.of(context).textTheme.caption,
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
