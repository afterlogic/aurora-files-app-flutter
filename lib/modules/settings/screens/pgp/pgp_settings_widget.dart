import 'package:aurorafiles/database/app_database.dart';
import 'package:aurorafiles/di/di.dart';
import 'package:aurorafiles/generated/i18n.dart';
import 'package:aurorafiles/modules/settings/screens/pgp/dialog/confirm_delete_key_widget.dart';
import 'package:aurorafiles/modules/settings/screens/pgp/dialog/create_key_dialog.dart';
import 'package:aurorafiles/modules/settings/screens/pgp/dialog/import_pgp_key_widget.dart';
import 'package:aurorafiles/modules/settings/screens/pgp/dialog/key_from_text_widget.dart';
import 'package:aurorafiles/modules/settings/screens/pgp/key/pgp_key_item_widget.dart';
import 'package:aurorafiles/modules/settings/screens/pgp/pgp_setting_presenter.dart';
import 'package:aurorafiles/modules/settings/screens/pgp/pgp_setting_view.dart';
import 'package:aurorafiles/shared_ui/app_button.dart';
import 'package:aurorafiles/utils/open_dialog.dart';
import 'package:aurorafiles/utils/stream_widget.dart';
import 'package:flutter/material.dart';

import 'key/export_pgp_key_route.dart';
import 'key/pgp_key_model_route.dart';

class PgpSettingWidget extends StatefulWidget {
  @override
  _PgpSettingWidgetState createState() => _PgpSettingWidgetState();
}

class _PgpSettingWidgetState extends State<PgpSettingWidget>
    with PgpSettingView {
  PgpSettingPresenter _presenter;

  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    _presenter = PgpSettingPresenter(this, DI.get(), DI.get());
    _presenter.refreshKeys();
    super.initState();
  }

  @override
  void dispose() {
    _presenter.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final theme = Theme.of(context);
    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
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

            final privateKeys =
            state.private.map((item) => KeyWidget(item, openKey)).toList();

            return ListView(
              padding: const EdgeInsets.only(left: 16, bottom: 25),
              children: <Widget>[
                if (publicKeys.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10, top: 25),
                    child: Text(
                      s.public_keys,
                      style: theme.textTheme.subhead,
                    ),
                  ),
                if (publicKeys.isNotEmpty)
                  Column(
                    children: publicKeys,
                  ),
                if (privateKeys.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10, top: 25),
                    child: Text(
                      s.private_keys,
                      style: theme.textTheme.subhead,
                    ),
                  ),
                if (privateKeys.isNotEmpty)
                  Column(
                    children: privateKeys,
                  ),
                SizedBox(
                  height: 25,
                ),
                if (publicKeys.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(right: 16),
                    child: AppButton(
                      text: s.export_all_public_keys.toUpperCase(),
                      onPressed: () {
                        exportAll(state.public);
                      },
                    ),
                  ),
                Padding(
                  padding: const EdgeInsets.only(right: 16),
                  child: AppButton(
                    text: s.import_keys_from_text.toUpperCase(),
                    onPressed: importKeyDialog,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 16),
                  child: AppButton(
                    text: s.import_keys_from_file.toUpperCase(),
                    onPressed: _presenter.getKeysFromFile,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 16),
                  child: AppButton(
                    text: s.generate_keys.toUpperCase(),
                    onPressed: generateKeyDialog,
                  ),
                ),
              ],
            );
          },
          initialData: KeysState([], [], true),
        ));
  }

  openKey(LocalPgpKey pgpKey) async {
    final result = await Navigator.pushNamed(
      context,
      PgpKeyModelRoute.name,
      arguments: [pgpKey, _presenter.pgpKeyUtil],
    );

    if (result == true) {
      _presenter.refreshKeys();
    }
  }

  exportAll(List<LocalPgpKey> keys) async {
    Navigator.pushNamed(context, PgpKeyExportRoute.name,
        arguments: [keys, _presenter.pgpKeyUtil]);
  }

  @override
  importKeyDialog() async {
    final result = await openDialog(context, (_) => KeyFromTextWidget());
    if (result is String) {
      _presenter.getKeysFromText(result);
    }
  }

  @override
  showImportDialog(List<LocalPgpKey> keys) async {
    final result = await openDialog(
        context, (_) => ImportPgpKeyWidget(keys, _presenter.pgpKeyUtil));
    if (result is List<LocalPgpKey>) {
      _presenter.saveKeys(result);
    }
  }

  generateKeyDialog() async {
    final result = await openDialog(
        context, (_) => CreateKeyDialog(_presenter.pgpKeyUtil));
    if (result is CreateKeyResult) {
      _presenter.addPrivateKey(result);
    }
  }
}
