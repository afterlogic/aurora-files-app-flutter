import 'package:aurora_ui_kit/aurora_ui_kit.dart';
import 'package:aurorafiles/database/app_database.dart';
import 'package:aurorafiles/l10n/l10n.dart';
import 'package:aurorafiles/modules/settings/repository/pgp_key_util.dart';
import 'package:aurorafiles/override_platform.dart';
import 'package:aurorafiles/shared_ui/aurora_snack_bar.dart';
import 'package:aurorafiles/shared_ui/layout_config.dart';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

class ExportPgpKeyWidget extends StatefulWidget {
  final List<LocalPgpKey> _pgpKeys;
  final PgpKeyUtil _pgpKeyUtil;

  const ExportPgpKeyWidget(this._pgpKeys, this._pgpKeyUtil, {super.key});

  @override
  _ExportPgpKeyWidgetState createState() => _ExportPgpKeyWidgetState();
}

class _ExportPgpKeyWidgetState extends State<ExportPgpKeyWidget> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final s = context.l10n;
    var keysText = "";
    for (LocalPgpKey key in widget._pgpKeys) {
      if (key.key.isNotEmpty) keysText += key.key + "\n\n";
    }
    final isTablet = LayoutConfig.of(context).isTablet;
    return Scaffold(
      key: _scaffoldKey,
      appBar: isTablet
          ? null
          : AMAppBar(
              title: Text(s.all_public_keys),
            ),
      body: SafeArea(
        child: Flex(
          crossAxisAlignment: CrossAxisAlignment.start,
          direction: Axis.vertical,
          children: <Widget>[
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
                children: <Widget>[
                  if (isTablet)
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SizedBox(
                        width: double.infinity,
                        child: Center(
                          child: Text(
                            s.all_public_keys,
                            style: Theme.of(context).textTheme.headline6,
                          ),
                        ),
                      ),
                    ),
                  const SizedBox(height: 20),
                  SelectableText(
                    keysText,
                  ),
                ],
              ),
            ),
            buttons(context, keysText),
          ],
        ),
      ),
    );
  }

  Widget buttons(BuildContext context, String keysText) {
    final s = context.l10n;
    final isTablet = LayoutConfig.of(context).isTablet;
    final space = isTablet
        ? const SizedBox.shrink()
        : const SizedBox(
            height: 10.0,
            width: 10,
          );
    final children = <Widget>[
      AMButton(
        child: Text(s.send_all),
        onPressed: () => share(keysText),
      ),
      if (!PlatformOverride.isIOS) ...[
        space,
        AMButton(
          onPressed: download,
          child: Text(s.download_all),
        ),
      ]
    ];
    return Padding(
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
    );
  }

  share(String keys) {
    Share.share(
      keys,
      subject: "PGP public keys",
      sharePositionOrigin: Rect.fromCenter(
        center: MediaQuery.of(context).size.bottomCenter(Offset.zero),
        width: 0,
        height: 0,
      ),
    );
  }

  download() async {
    final s = context.l10n;
    final result = await widget._pgpKeyUtil.downloadPublicKeys(widget._pgpKeys);
    AuroraSnackBar.showSnack(
      msg: s.downloading_to(result.path),
      isError: false,
    );
  }
}
