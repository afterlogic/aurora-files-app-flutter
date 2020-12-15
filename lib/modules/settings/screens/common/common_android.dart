import 'package:aurorafiles/generated/s_of_context.dart';
import 'package:aurorafiles/modules/app_store.dart';
import 'package:aurorafiles/shared_ui/layout_config.dart';
import 'package:aurorafiles/utils/show_snack.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:aurora_ui_kit/aurora_ui_kit.dart';

import 'components/theme_selection_dialog.dart';

class CommonSettingsAndroid extends StatefulWidget {
  @override
  _CommonSettingsAndroidState createState() => _CommonSettingsAndroidState();
}

class _CommonSettingsAndroidState extends State<CommonSettingsAndroid> {
  final _settingsState = AppStore.settingsState;
  final scaffoldKey = new GlobalKey<ScaffoldState>();
  S s;

  Future _clearCache() async {
    final result = await AMConfirmationDialog.show(
      context,
      s.clear_cache,
      s.confirm_delete,
      s.clear,
      s.cancel,
    );
    if (result == true) {
      await AppStore.filesState.clearCache(deleteCachedImages: true);
      showSnack(
          context: context,
          scaffoldState: scaffoldKey.currentState,
          isError: false,
          msg: s.cache_cleared_success);
    }
  }

  String _getThemeName(bool isDarkTheme) {
    s = Str.of(context);
    if (isDarkTheme == false)
      return s.light_theme;
    else if (isDarkTheme == true)
      return s.dark_theme;
    else
      return s.system_theme;
  }

  @override
  Widget build(BuildContext context) {
    s = Str.of(context);
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
              leading: AMCircleIcon(MdiIcons.themeLightDark),
              title: Text(s.app_theme),
              trailing: Text(
                _getThemeName(_settingsState.isDarkTheme),
                style: Theme.of(context).textTheme.caption,
              ),
              onTap: () => ThemeSelectionDialog.show(
                  context,
                  _settingsState.isDarkTheme,
                  (val) => _settingsState.toggleDarkTheme(val)),
            ),
          ),
          ListTile(
            leading: AMCircleIcon(MdiIcons.broom),
            title: Text(s.clear_cache),
            onTap: _clearCache,
          ),
        ],
      ),
    );
  }
}
