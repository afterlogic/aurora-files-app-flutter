import 'package:aurora_ui_kit/aurora_ui_kit.dart';
import 'package:aurorafiles/database/app_database.dart';
import 'package:aurorafiles/generated/s_of_context.dart';
import 'package:aurorafiles/modules/settings/repository/pgp_key_util.dart';
import 'package:aurorafiles/modules/settings/screens/pgp/dialog/confirm_delete_key_widget.dart';
import 'package:aurorafiles/override_platform.dart';
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
  S s;

  @override
  Widget build(BuildContext context) {
    s = Str.of(context);
    final theme = Theme.of(context);
    return Scaffold(
      key: _scaffoldKey,
      appBar: AMAppBar(
        titleSpacing: NavigationToolbar.kMiddleSpacing,
        title: Text(widget._pgpKey.isPrivate ? s.private_key : s.public_key),
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
                    SelectableText(
                      widget._pgpKey.key,
                    ),
                  ],
                ),
              ),
              Flexible(
                flex: orientation == Orientation.landscape ? 2 : 0,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(
                      height: 8,
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: AMButton(
                        child: Text(s.share),
                        onPressed: share,
                      ),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    if (!PlatformOverride.isIOS)
                      SizedBox(
                        width: double.infinity,
                        child: AMButton(
                          child: Text(s.download),
                          onPressed: download,
                        ),
                      ),
                    if (!PlatformOverride.isIOS)
                      SizedBox(
                        height: 8,
                      ),
                    if (widget._pgpKey.id != null)
                      SizedBox(
                        width: double.infinity,
                        child: AMButton(
                          child: Text(s.delete),
                          onPressed: delete,
                        ),
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

  share() async {
    if (widget._pgpKey.isPrivate) {
      final result = await AMConfirmationDialog.show(
        context,
        s.label_pgp_share_warning,
        s.hint_pgp_share_warning,
        s.share,
        s.cancel,
      );
      if (result != true) {
        return;
      }
    }
    ShareExtend.share(widget._pgpKey.key, "text");
  }

  download() async {
    if (widget._pgpKey.isPrivate) {
      final result = await AMConfirmationDialog.show(
        context,
        s.label_pgp_share_warning,
        s.hint_pgp_share_warning,
        s.share,
        s.cancel,
      );
      if (result != true) {
        return;
      }
    }
    final result = await widget._pgpKeyUtil.downloadKey(widget._pgpKey);

    showSnack(
      context: context,
      scaffoldState: _scaffoldKey.currentState,
      msg: s.downloading_to(result.path),
      isError: false,
    );
  }

  delete() async {
    final result = await AMDialog.show(
      context: context,
      builder: (_) {
        return ConfirmDeleteKeyWidget(
            s.confirm_delete_pgp_key(widget._pgpKey.email));
      },
    );
    if (result == true) {
      await widget._pgpKeyUtil.deleteKey(widget._pgpKey);
      Navigator.pop(context, true);
    }
  }
}
