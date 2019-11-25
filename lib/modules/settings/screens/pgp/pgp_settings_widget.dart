import 'package:aurorafiles/database/app_database.dart';
import 'package:aurorafiles/di/di.dart';
import 'package:aurorafiles/modules/settings/screens/pgp/dialog/import_pgp_key_widget.dart';
import 'package:aurorafiles/modules/settings/screens/pgp/dialog/key_from_text_widget.dart';
import 'package:aurorafiles/modules/settings/screens/pgp/key/pgp_key_item_widget.dart';
import 'package:aurorafiles/modules/settings/screens/pgp/pgp_setting_presenter.dart';
import 'package:aurorafiles/modules/settings/screens/pgp/pgp_setting_view.dart';
import 'package:aurorafiles/shared_ui/app_button.dart';
import 'package:aurorafiles/utils/open_dialog.dart';
import 'package:aurorafiles/utils/show_snack.dart';
import 'package:aurorafiles/utils/stream_widget.dart';
import 'package:flutter/material.dart';
import 'package:share_extend/share_extend.dart';

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
    _presenter.getPublicKey();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: Text("OpenPGP"),
        ),
        body: StreamWidget<KeysState>(
          keysState,
          (_, state) {
            if (state.isProgress) {
              return SizedBox.shrink();
            }

            final keysWidget =
                state.keys.map((item) => KeyWidget(item, openKey)).toList();
            return ListView(
              padding: const EdgeInsets.only(left: 16, bottom: 25),
              children: <Widget>[
                if (keysWidget.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10, top: 25),
                    child: Text(
                      "Public keys",
                      style: theme.textTheme.subhead,
                    ),
                  ),
                if (keysWidget.isNotEmpty)
                  Column(
                    children: keysWidget,
                  ),
                SizedBox(
                  height: 25,
                ),
                if (keysWidget.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(right: 16),
                    child: AppButton(
                      text: "Export all public keys".toUpperCase(),
                      onPressed: () {
                        exportAll(state.keys);
                      },
                    ),
                  ),
                Padding(
                  padding: const EdgeInsets.only(right: 16),
                  child: AppButton(
                    text: "Import keys from text".toUpperCase(),
                    onPressed: importKeyDialog,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 16),
                  child: AppButton(
                    text: "Import keys from file".toUpperCase(),
                    onPressed: _presenter.getKeysFromFile,
                  ),
                ),
              ],
            );
          },
          initialData: KeysState([], true),
        ));
  }

  openKey(LocalPgpKey pgpKey) async {
    final result = await Navigator.pushNamed(
      context,
      PgpKeyModelRoute.name,
      arguments: [pgpKey, _presenter.pgpKeyUtil],
    );

    if (result == true) {
      _presenter.getPublicKey();
    }
  }

  exportAll(List<LocalPgpKey> keys) async {
    final path = await _presenter.exportAll(keys);
    showSnack(
      context: context,
      scaffoldState: _scaffoldKey.currentState,
      msg: "Downloading $path",
      isError: false,
    );
  }

  @override
  importKeyDialog() async {
    final result = await openDialog(context, (_) => KeyFromTextWidget());
    if (result is String) {
      _presenter.getKeysFromText(result);
    }
  }

  showImportDialog(List<LocalPgpKey> keys) async {
    final result = await openDialog(
        context, (_) => ImportPgpKeyWidget(keys, _presenter.pgpKeyUtil));
    if (result is List<LocalPgpKey>) {
      _presenter.saveKeys(result);
    }
  }
}
