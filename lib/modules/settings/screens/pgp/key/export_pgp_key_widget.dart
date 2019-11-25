import 'package:aurorafiles/database/app_database.dart';
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

  @override
  Widget build(BuildContext context) {
    var keysText = "";
    for (LocalPgpKey key in widget._pgpKeys) {
      keysText += key.key + "\n\n";
    }
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text("All public keys"),
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
                    Text(
                      keysText,
                      maxLines: null,
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
                      text: "Send all".toUpperCase(),
                      onPressed: () => share(keysText),
                    ),
                    AppButton(
                      width: double.infinity,
                      text: "Download all".toUpperCase(),
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
    final result = await widget._pgpKeyUtil.downloadKeys(widget._pgpKeys);

    showSnack(
      context: context,
      scaffoldState: _scaffoldKey.currentState,
      msg: "Downloading ${result.path}",
      isError: false,
    );
  }
}
