import 'package:aurora_ui_kit/aurora_ui_kit.dart';
import 'package:aurorafiles/database/app_database.dart';
import 'package:aurorafiles/l10n/l10n.dart';
import 'package:aurorafiles/modules/settings/repository/pgp_key_util.dart';
import 'package:aurorafiles/modules/settings/screens/pgp/dialog/confirm_delete_key_widget.dart';
import 'package:aurorafiles/modules/settings/screens/pgp/pgp_setting_presenter.dart';
import 'package:aurorafiles/override_platform.dart';
import 'package:aurorafiles/shared_ui/aurora_snack_bar.dart';
import 'package:aurorafiles/shared_ui/layout_config.dart';
import 'package:flutter/material.dart';
import 'package:share/share.dart';

class PgpKeyModelWidget extends StatefulWidget {
  final LocalPgpKey _pgpKey;
  final PgpKeyUtil _pgpKeyUtil;
  final PgpSettingPresenter presenter;

  const PgpKeyModelWidget(this.presenter, this._pgpKey, this._pgpKeyUtil,
      {super.key});

  @override
  _PgpKeyModelWidgetState createState() => _PgpKeyModelWidgetState();
}

class _PgpKeyModelWidgetState extends State<PgpKeyModelWidget>
    with WidgetsBindingObserver {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  bool isPoped = false;

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
    final s = context.l10n;
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
                            style: Theme.of(context).textTheme.headline6,
                          ),
                        ),
                      ),
                    ),
                  const SizedBox(
                    height: 8,
                  ),
                  Text(
                    widget._pgpKey.email,
                    style: theme.textTheme.headline6,
                  ),
                  const SizedBox(
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
        onPressed: share,
        child: Text(s.share),
      ),
      space,
      if (!PlatformOverride.isIOS) ...[
        AMButton(
          onPressed: download,
          child: Text(s.download),
        ),
        space,
      ],
      AMButton(
        onPressed: delete,
        child: Text(s.delete),
      ),
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

  Future<void> share() async {
    final s = context.l10n;
    final center = MediaQuery.of(context).size.bottomCenter(Offset.zero);
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
        center: center,
        width: 0,
        height: 0,
      ),
    );
  }

  download() async {
    final s = context.l10n;
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
    AuroraSnackBar.showSnack(
      msg: s.downloading_to(result.path),
      isError: false,
    );
  }

  Future<void> delete() async {
    final s = context.l10n;
    final result = await AMDialog.show(
      context: context,
      builder: (_) {
        return ConfirmDeleteKeyWidget(
            s.confirm_delete_pgp_key(widget._pgpKey.email));
      },
    );
    if (result == true) {
      if (widget._pgpKey.id != -1) {
        await widget._pgpKeyUtil.deleteKey(widget._pgpKey);
      } else {
        widget.presenter.deleteKey(widget._pgpKey.email);
      }
      if (!mounted) return;
      Navigator.pop(context, true);
    }
  }
}
