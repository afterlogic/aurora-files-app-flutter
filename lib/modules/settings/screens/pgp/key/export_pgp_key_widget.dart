import 'dart:io';

import 'package:aurorafiles/database/app_database.dart';
import 'package:aurorafiles/generated/s_of_context.dart';
import 'package:aurorafiles/modules/settings/repository/pgp_key_util.dart';
import 'package:aurorafiles/shared_ui/app_button.dart';
import 'package:aurorafiles/utils/show_snack.dart';
import 'package:flutter/material.dart';
import 'package:share_extend/share_extend.dart';

class ExportPgpKeyWidget extends StatefulWidget {
  final List<LocalPgpKey> _pgpKeys;
  final PgpKeyUtil _pgpKeyUtil;

  const ExportPgpKeyWidget(this._pgpKeys, this._pgpKeyUtil);

  @override
  _ExportPgpKeyWidgetState createState() => _ExportPgpKeyWidgetState();
}

class _ExportPgpKeyWidgetState extends State<ExportPgpKeyWidget> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  S s;

  @override
  Widget build(BuildContext context) {
    s = Str.of(context);
    var keysText = "";
    for (LocalPgpKey key in widget._pgpKeys) {
      if (key.key != null) keysText += key.key + "\n\n";
    }
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(s.all_public_keys),
      ),
      body: OrientationBuilder(
        builder: (context, orientation) => Padding(
          padding: const EdgeInsets.all(20),
          child: Flex(
            direction: orientation == Orientation.landscape
                ? Axis.horizontal
                : Axis.vertical,
            children: <Widget>[
              Flexible(
                flex: 3,
                child: ListView(
                  children: <Widget>[
                    SizedBox(
                      height: 20,
                    ),
                    SelectableText(
                      keysText,
                    ),
                  ],
                ),
              ),
              Flexible(
                flex: orientation == Orientation.landscape ? 2 : 0,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    AppButton(
                      width: double.infinity,
                      text: s.send_all.toUpperCase(),
                      onPressed: () => share(keysText),
                    ),
                    if (!Platform.isIOS)
                      AppButton(
                        width: double.infinity,
                        text: s.download_all.toUpperCase(),
                        onPressed: download,
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  share(String keys) {
    ShareExtend.share(keys, "text");
  }

  download() async {
    final result = await widget._pgpKeyUtil.downloadPublicKeys(widget._pgpKeys);

    showSnack(
      context: context,
      scaffoldState: _scaffoldKey.currentState,
      msg: s.downloading_to(result.path),
      isError: false,
    );
  }
}
