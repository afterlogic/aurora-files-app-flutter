import 'package:aurora_ui_kit/aurora_ui_kit.dart';
import 'package:aurorafiles/database/app_database.dart';
import 'package:aurorafiles/di/di.dart';
import 'package:aurorafiles/generated/s_of_context.dart';
import 'package:aurorafiles/modules/files/dialogs/key_request_dialog.dart';
import 'package:aurorafiles/modules/settings/screens/pgp/dialog/create_key_dialog.dart';
import 'package:aurorafiles/modules/settings/screens/pgp/dialog/key_from_text_widget.dart';
import 'package:aurorafiles/modules/settings/screens/pgp/key/pgp_key_item_widget.dart';
import 'package:aurorafiles/modules/settings/screens/pgp/pgp_setting_presenter.dart';
import 'package:aurorafiles/modules/settings/screens/pgp/pgp_setting_view.dart';
import 'package:aurorafiles/modules/settings/settings_navigator.dart';
import 'package:aurorafiles/shared_ui/error_dialog.dart';
import 'package:aurorafiles/shared_ui/layout_config.dart';
import 'package:aurorafiles/utils/show_snack.dart';
import 'package:aurorafiles/utils/stream_widget.dart';
import 'package:flutter/material.dart';

import 'dialog/import_key_dialog.dart';
import 'key/export_pgp_key_route.dart';
import 'key/pgp_key_model_route.dart';

class PgpSettingWidget extends StatefulWidget {
  @override
  _PgpSettingWidgetState createState() => _PgpSettingWidgetState();
}

class _PgpSettingWidgetState extends State<PgpSettingWidget>
    with PgpSettingView {
  PgpSettingPresenter _presenter;
  S s;
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    _presenter = PgpSettingPresenter(this, DI.get());
    _presenter.refreshKeys();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    s = Str.of(context);
    final isTablet = LayoutConfig.of(context).isTablet;
    final theme = Theme.of(context);
    return Scaffold(
        key: _scaffoldKey,
        appBar: isTablet
            ? null
            : AMAppBar(
                title: Text(s.openPGP),
              ),
        body: StreamWidget<KeysState>(
          keysState,
          (_, state) {
            if (state.isProgress) {
              return SizedBox.shrink();
            }

            final publicKeys =
                state.public.map((item) => KeyWidget(item, openKey)).toList();
            final externalKeys = state.external
                ?.map((item) => KeyWidget(item, openKey))
                ?.toList();
            final privateKeys =
                state.private.map((item) => KeyWidget(item, openKey)).toList();

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                    children: <Widget>[
                      CheckboxListTile(
                        value: state.storePassword,
                        title: Text(s.label_store_password_in_session),
                        onChanged: (bool value) {
                          _presenter.setStorePassword(value);
                        },
                      ),
                      if (publicKeys.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 10, top: 25),
                          child: Text(
                            s.public_keys,
                            style: theme.textTheme.subtitle1,
                          ),
                        ),
                      if (publicKeys.isNotEmpty) Column(children: publicKeys),
                      if (privateKeys.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 10, top: 25),
                          child: Text(
                            s.private_keys,
                            style: theme.textTheme.subtitle1,
                          ),
                        ),
                      if (privateKeys.isNotEmpty) Column(children: privateKeys),
                      if (externalKeys?.isNotEmpty == true)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.only(bottom: 10, top: 25),
                              child: Text(
                                s.label_pgp_contact_public_keys,
                                style: theme.textTheme.subtitle1,
                              ),
                            ),
                            ...externalKeys,
                          ],
                        ),
                      if (externalKeys == null)
                        Padding(
                          padding: EdgeInsets.all(16),
                          child: Center(
                            child: CircularProgressIndicator(),
                          ),
                        ),
                    ],
                  ),
                ),
                buttons(context, state, externalKeys),
              ],
            );
          },
          initialData: KeysState([], [], [], null, true),
        ));
  }

  Widget buttons(
      BuildContext context, KeysState state, List<KeyWidget> externalKeys) {
    final isTablet = LayoutConfig.of(context).isTablet;
    final space = isTablet
        ? SizedBox.shrink()
        : SizedBox(
            height: 10.0,
            width: 10,
          );
    final children = <Widget>[
      if (externalKeys?.isNotEmpty == true)
        AMButton(
          child: Text(s.export_all_public_keys),
          onPressed: () {
            exportAll(state.external);
          },
        ),
      if (externalKeys?.isNotEmpty == true) space,
      AMButton(
        child: Text(s.import_keys_from_text),
        onPressed: importKeyDialog,
      ),
      space,
      AMButton(
        child: Text(s.import_keys_from_file),
        onPressed: _presenter.getKeysFromFile,
      ),
      space,
      AMButton(
        child: Text(s.generate_keys),
        onPressed: generateKeyDialog,
      ),
    ];
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 8),
        child: isTablet
            ? Wrap(
                spacing: 10,
                runSpacing: 10,
                children: children,
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: children,
              ),
      ),
    );
  }

  Future<void> openKey(LocalPgpKey pgpKey) async {
    if (pgpKey.key == null) return;
    if (pgpKey.isPrivate) {
      final password = await KeyRequestDialog.request(context);
      if (password == null) {
        return;
      }
    }
    final result = await SettingsNavigatorWidget.of(context).pushNamed(
      PgpKeyModelRoute.name,
      arguments: [_presenter, pgpKey, _presenter.pgpKeyUtil],
    );

    if (result == true) {
      _presenter.refreshKeys();
    }
  }

  exportAll(List<LocalPgpKey> keys) async {
    SettingsNavigatorWidget.of(context).pushNamed(
      PgpKeyExportRoute.name,
      arguments: [keys, _presenter.pgpKeyUtil],
    );
  }

  @override
  Future<void> importKeyDialog() async {
    final result = await AMDialog.show(
      context: context,
      builder: (_) => KeyFromTextWidget(),
    );
    if (result is String) {
      _presenter.getKeysFromText(result);
    }
  }

  @override
  Future<void> showImportDialog(PgpKeyMap keys) async {
    AMDialog.show(
      context: context,
      builder: (_) => ImportKeyDialog(
        keys.userKeys,
        keys.contactKeys,
        keys.alienKeys,
        _presenter,
      ),
    );
  }

  Future<void> keysNotFound() async {
    AMDialog.show(
      context: context,
      builder: (_) => ErrorDialog(s.failed, s.keys_not_found),
    );
  }

  Future<void> generateKeyDialog() async {
    final result = await AMDialog.show(
      context: context,
      builder: (_) => CreateKeyDialog(_presenter.pgpKeyUtil),
    );
    if (result is CreateKeyResult) {
      _presenter.addPrivateKey(result);
    }
  }

  @override
  Future<void> showError(String error) async {
    showSnack(
      context,
      msg: error,
      isError: true,
    );
  }
}
