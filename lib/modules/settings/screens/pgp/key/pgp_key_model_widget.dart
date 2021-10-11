import 'package:aurora_ui_kit/aurora_ui_kit.dart';
import 'package:aurorafiles/database/app_database.dart';
import 'package:aurorafiles/generated/s_of_context.dart';
import 'package:aurorafiles/modules/settings/repository/pgp_key_util.dart';
import 'package:aurorafiles/modules/settings/screens/pgp/dialog/confirm_delete_key_widget.dart';
import 'package:aurorafiles/modules/settings/screens/pgp/pgp_setting_presenter.dart';
import 'package:aurorafiles/override_platform.dart';
import 'package:aurorafiles/shared_ui/layout_config.dart';
import 'package:aurorafiles/utils/show_snack.dart';
import 'package:flutter/material.dart';
import 'package:share/share.dart';

class PgpKeyModelWidget extends StatefulWidget {
  final LocalPgpKey _pgpKey;
  final PgpKeyUtil _pgpKeyUtil;
  final PgpSettingPresenter presenter;

  const PgpKeyModelWidget(this.presenter, this._pgpKey, this._pgpKeyUtil);

  @override
  _PgpKeyModelWidgetState createState() => _PgpKeyModelWidgetState();
}

class _PgpKeyModelWidgetState extends State<PgpKeyModelWidget>
    with WidgetsBindingObserver {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  bool isPoped = false;
  S s;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.inactive && !isPoped) {
      isPoped = true;
      Navigator.pop(context);
    }
    super.didChangeAppLifecycleState(state);
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
              titleSpacing: NavigationToolbar.kMiddleSpacing,
              title:
                  Text(widget._pgpKey.isPrivate ? s.private_key : s.public_key),
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
                            widget._pgpKey.isPrivate
                                ? s.private_key
                                : s.public_key,
                            style: Theme.of(context).textTheme.title,
                          ),
                        ),
                      ),
                    ),
                  SizedBox(
                    height: 8,
                  ),
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
            buttons(context),
          ],
        ),
      ),
    );
  }

  Widget buttons(BuildContext context) {
    final isTablet = LayoutConfig.of(context).isTablet;
    final space = isTablet
        ? SizedBox.shrink()
        : SizedBox(
            height: 10.0,
            width: 10,
          );
    final children = <Widget>[
      AMButton(
        child: Text(s.share),
        onPressed: share,
      ),
      space,
      if (!PlatformOverride.isIOS) ...[
        AMButton(
          child: Text(s.download),
          onPressed: download,
        ),
        space,
      ],
      AMButton(
        child: Text(s.delete),
        onPressed: delete,
      ),
    ];
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 32, vertical: 8),
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
    Share.share(
      widget._pgpKey.key,
      subject: widget._pgpKey.name,
      sharePositionOrigin: Rect.fromCenter(
        center: MediaQuery.of(context).size.bottomCenter(Offset.zero),
        width: 0,
        height: 0,
      ),
    );
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
      if (widget._pgpKey.id != null) {
        await widget._pgpKeyUtil.deleteKey(widget._pgpKey);
      } else {
        widget.presenter.deleteKey(widget._pgpKey.email);
      }
      Navigator.pop(context, true);
    }
  }
}
