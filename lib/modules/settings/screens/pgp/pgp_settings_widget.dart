import 'package:aurorafiles/database/app_database.dart';
import 'package:aurorafiles/di/di.dart';
import 'package:aurorafiles/modules/settings/screens/pgp/dialog/key_from_text_widget.dart';
import 'package:aurorafiles/modules/settings/screens/pgp/pgp_setting_presenter.dart';
import 'package:aurorafiles/modules/settings/screens/pgp/pgp_setting_view.dart';
import 'package:aurorafiles/shared_ui/app_button.dart';
import 'package:aurorafiles/utils/open_dialog.dart';
import 'package:aurorafiles/utils/stream_widget.dart';
import 'package:flutter/material.dart';

class PgpSettingWidget extends StatefulWidget {
  @override
  _PgpSettingWidgetState createState() => _PgpSettingWidgetState();
}

class _PgpSettingWidgetState extends State<PgpSettingWidget>
    with PgpSettingView {
  PgpSettingPresenter _presenter;

  @override
  void initState() {
    _presenter = PgpSettingPresenter(this, DI.get());
    _presenter.getPublicKey();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
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
                state.keys.map((item) => KeyWidget(item)).toList();
            return ListView(
              padding: const EdgeInsets.only(left: 16, bottom: 25),
              children: <Widget>[
                if (keysWidget.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 25, top: 25),
                    child: Text(
                      "Public keys",
                      style: theme.textTheme.subhead,
                    ),
                  ),
                Column(
                  children: keysWidget,
                ),
                SizedBox(
                  height: 36,
                ),
                if (keysWidget.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(right: 16),
                    child: AppButton(
                      text: "Export all public keys".toUpperCase(),
                      onPressed: () {},
                    ),
                  ),
                Padding(
                  padding: const EdgeInsets.only(right: 16),
                  child: AppButton(
                    text: "Import keys from text".toUpperCase(),
                    onPressed: () {
                      openDialog(context, (_) => KeyFromTextWidget());
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 16),
                  child: AppButton(
                    text: "Import keys from file".toUpperCase(),
                    onPressed: () {},
                  ),
                ),
              ],
            );
          },
          initialData: KeysState([], true),
        ));
  }
}

class KeyWidget extends StatelessWidget {
  final LocalPgpKey pgpKey;

  const KeyWidget(this.pgpKey);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SizedBox(
      height: 55,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                pgpKey.email,
                maxLines: 1,
                style: theme.textTheme.subhead,
              ),
              Padding(
                padding: const EdgeInsets.only(right: 16),
                child: Icon(Icons.arrow_forward_ios),
              ),
            ],
          ),
          Divider(),
        ],
      ),
    );
  }
}
