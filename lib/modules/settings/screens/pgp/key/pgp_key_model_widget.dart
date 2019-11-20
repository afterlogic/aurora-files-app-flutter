import 'package:aurorafiles/database/app_database.dart';
import 'package:aurorafiles/modules/settings/repository/pgp_key_util.dart';
import 'package:aurorafiles/shared_ui/app_button.dart';
import 'package:aurorafiles/utils/show_snack.dart';
import 'package:flutter/material.dart';
import 'package:share_extend/share_extend.dart';

class PgpKeyModelWidget extends StatefulWidget {
  final LocalPgpKey _pgpKey;
  final PgpKeyUtil _pgpKeyUtil;

  const PgpKeyModelWidget(this._pgpKey, this._pgpKeyUtil);

  @override
  _PgpKeyModelWidgetState createState() => _PgpKeyModelWidgetState();
}

class _PgpKeyModelWidgetState extends State<PgpKeyModelWidget> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(widget._pgpKey.isPrivate ? "Private key" : "Public key"),
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
                    Text(
                      widget._pgpKey.email,
                      style: theme.textTheme.title,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      widget._pgpKey.key,
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
                      text: "Share".toUpperCase(),
                      onPressed: share,
                    ),
                    AppButton(
                      width: double.infinity,
                      text: "Download".toUpperCase(),
                      onPressed: download,
                    ),
                    AppButton(
                      width: double.infinity,
                      text: "Delete".toUpperCase(),
                      onPressed: delete,
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

  share() {
    ShareExtend.share(widget._pgpKey.key, "text");
  }

  download() async {
    final result = await widget._pgpKeyUtil.downloadKey(widget._pgpKey);

    showSnack(
      context: context,
      scaffoldState: _scaffoldKey.currentState,
      msg: "Downloading ${result.path}",
      isError: false,
    );
  }

  delete() async {
    await widget._pgpKeyUtil.deleteKey(widget._pgpKey);
    Navigator.pop(context, true);
  }
}
