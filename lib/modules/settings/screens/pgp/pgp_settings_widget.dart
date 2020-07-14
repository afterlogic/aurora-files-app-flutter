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
import 'package:aurorafiles/shared_ui/error_dialog.dart';
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
    final theme = Theme.of(context);
    final spacer = SizedBox(height: 10.0);
    return Scaffold(
        key: _scaffoldKey,
        appBar: AMAppBar(
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
            final userKeys =
                state.user?.map((item) => KeyWidget(item, openKey))?.toList();
            final privateKeys =
                state.private.map((item) => KeyWidget(item, openKey)).toList();

            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: <Widget>[
                  Expanded(
                    child: ListView(
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
                              style: theme.textTheme.subhead,
                            ),
                          ),
                        if (publicKeys.isNotEmpty) Column(children: publicKeys),
                        if (privateKeys.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 10, top: 25),
                            child: Text(
                              s.private_keys,
                              style: theme.textTheme.subhead,
                            ),
                          ),
                        if (privateKeys.isNotEmpty)
                          Column(children: privateKeys),
                        if (userKeys?.isEmpty != true)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 10, top: 25),
                            child: Text(
                              s.label_pgp_contact_public_keys,
                              style: theme.textTheme.subhead,
                            ),
                          ),
                        if (userKeys?.isNotEmpty == true)
                          Column(children: userKeys),
                        if (userKeys == null)
                          Padding(
                            padding: EdgeInsets.all(16),
                            child: Center(
                              child: CircularProgressIndicator(),
                            ),
                          ),
                      ],
                    ),
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      SizedBox(height: 25),
                      if (publicKeys.isNotEmpty)
                        SizedBox(
                          width: double.infinity,
                          child: AMButton(
                            child: Text(s.export_all_public_keys),
                            onPressed: () {
                              exportAll(state.public);
                            },
                          ),
                        ),
                      if (publicKeys.isNotEmpty) spacer,
                      SizedBox(
                        width: double.infinity,
                        child: AMButton(
                          child: Text(s.import_keys_from_text),
                          onPressed: importKeyDialog,
                        ),
                      ),
                      spacer,
                      SizedBox(
                        width: double.infinity,
                        child: AMButton(
                          child: Text(s.import_keys_from_file),
                          onPressed: _presenter.getKeysFromFile,
                        ),
                      ),
                      spacer,
                      SizedBox(
                        width: double.infinity,
                        child: AMButton(
                          child: Text(s.generate_keys),
                          onPressed: generateKeyDialog,
                        ),
                      ),
                    ],
                  )
                ],
              ),
            );
          },
          initialData: KeysState([], [], [], null, true),
        ));
  }

  openKey(LocalPgpKey pgpKey) async {
    if (pgpKey.key == null) return;
    if (pgpKey.isPrivate) {
      final password = await KeyRequestDialog.request(context);
      if(password==null){
        return;
      }
    }
    final result = await Navigator.pushNamed(
      context,
      PgpKeyModelRoute.name,
      arguments: [_presenter, pgpKey, _presenter.pgpKeyUtil],
    );

    if (result == true) {
      _presenter.refreshKeys();
    }
  }

  exportAll(List<LocalPgpKey> keys) async {
    Navigator.pushNamed(
      context,
      PgpKeyExportRoute.name,
      arguments: [keys, _presenter.pgpKeyUtil],
    );
  }

  @override
  importKeyDialog() async {
    final result = await AMDialog.show(
      context: context,
      builder: (_) => KeyFromTextWidget(),
    );
    if (result is String) {
      _presenter.getKeysFromText(result);
    }
  }

  @override
  showImportDialog(PgpKeyMap keys) async {
    final result = await AMDialog.show(
      context: context,
      builder: (_) => ImportKeyDialog(
        keys.userKey,
        keys.contactKey,
        _presenter,
      ),
    );
  }

  keysNotFound() {
    AMDialog.show(
      context: context,
      builder: (_) => ErrorDialog(s.failed, s.keys_not_found),
    );
  }

  generateKeyDialog() async {
    final result = await AMDialog.show(
      context: context,
      builder: (_) => CreateKeyDialog(_presenter.pgpKeyUtil),
    );
    if (result is CreateKeyResult) {
      _presenter.addPrivateKey(result);
    }
  }

  @override
  showError(String error) {
    showSnack(
      context: context,
      scaffoldState: _scaffoldKey.currentState,
      msg: error,
      isError: true,
    );
  }
}
