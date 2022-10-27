import 'package:aurorafiles/l10n/l10n.dart';
import 'package:aurorafiles/modules/app_store.dart';
import 'package:aurorafiles/shared_ui/aurora_snack_bar.dart';
import 'package:aurorafiles/shared_ui/layout_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:aurora_ui_kit/aurora_ui_kit.dart';

import 'components/theme_selection_dialog.dart';

class CommonSettingsAndroid extends StatefulWidget {
  const CommonSettingsAndroid({super.key});

  @override
  _CommonSettingsAndroidState createState() => _CommonSettingsAndroidState();
}

class _CommonSettingsAndroidState extends State<CommonSettingsAndroid> {
  final _settingsState = AppStore.settingsState;
  final scaffoldKey = GlobalKey<ScaffoldState>();

  Future _clearCache() async {
    final s = context.l10n;
    final result = await AMConfirmationDialog.show(
      context,
      s.clear_cache,
      s.confirm_delete,
      s.clear,
      s.cancel,
    );
    if (result == true) {
      await AppStore.filesState.clearCache(deleteCachedImages: true);
      AuroraSnackBar.showSnack(
        msg: s.cache_cleared_success,
        isError: false,
      );
    }
  }

  String _getThemeName(bool? isDarkTheme) {
    final s = context.l10n;
    if (isDarkTheme == false) {
      return s.light_theme;
    } else if (isDarkTheme == true) {
      return s.dark_theme;
    } else {
      return s.system_theme;
    }
  }

  @override
  Widget build(BuildContext context) {
    final s = context.l10n;
    final isTablet = LayoutConfig.of(context).isTablet;
    return Scaffold(
      key: scaffoldKey,
      appBar: isTablet
          ? null
          : AMAppBar(
              title: Text(s.common),
            ),
      body: ListView(
        children: <Widget>[
          Observer(
            builder: (_) => ListTile(
              leading: const AMCircleIcon(MdiIcons.themeLightDark),
              title: Text(s.app_theme),
              trailing: Text(
                _getThemeName(_settingsState.isDarkTheme),
                style: Theme.of(context).textTheme.caption,
              ),
              onTap: () => ThemeSelectionDialog.show(
                context,
                _settingsState.isDarkTheme ?? false,
                (val) {
                  if (val != null) _settingsState.toggleDarkTheme(val);
                },
              ),
            ),
          ),
          ListTile(
            leading: const AMCircleIcon(MdiIcons.broom),
            title: Text(s.clear_cache),
            onTap: _clearCache,
          ),
        ],
      ),
    );
  }
}
