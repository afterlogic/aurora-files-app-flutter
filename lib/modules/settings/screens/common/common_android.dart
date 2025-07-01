import 'package:aurora_ui_kit/aurora_ui_kit.dart';
import 'package:aurorafiles/build_property.dart';
import 'package:aurorafiles/l10n/l10n.dart';
import 'package:aurorafiles/modules/app_store.dart';
import 'package:aurorafiles/modules/settings/screens/common/components/theme_selection_dialog.dart';
import 'package:aurorafiles/shared_ui/app_bar_icons.dart';
import 'package:aurorafiles/shared_ui/aurora_snack_bar.dart';
import 'package:aurorafiles/shared_ui/layout_config.dart';
import 'package:aurorafiles/shared_ui/settings_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

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
              leading: BuildProperty.flatDesign
                  ? IconButton(
                      icon: AppBarIcons.back(),
                      onPressed: () => Navigator.of(context).pop(),
                    )
                  : null,
              shadow: BuildProperty.flatDesign
                  ? const BoxShadow(color: Colors.transparent)
                  : null,
            ),
      body: Column(
        children: [
          if (BuildProperty.flatDesign)
            Divider(
              height: 1.0,
              thickness: 1.0,
              color: Theme.of(context).dividerColor,
            ),
          Expanded(
            child: ListView(
              children: <Widget>[
                if (!BuildProperty.alwaysLightTheme)
                  Observer(
                    builder: (_) => ListTile(
                      leading: SettingsIcons.appTheme(),
                      title: Text(s.app_theme),
                      trailing: Text(
                        _getThemeName(_settingsState.isDarkTheme),
                        style: Theme.of(context).textTheme.caption,
                      ),
                      onTap: () => ThemeSelectionDialog.show(
                        context,
                        _settingsState.isDarkTheme,
                        _settingsState.toggleDarkTheme,
                      ),
                    ),
                  ),
                if (!BuildProperty.alwaysLightTheme && BuildProperty.flatDesign)
                  Divider(
                    height: 1.0,
                    thickness: 1.0,
                    color: Theme.of(context).dividerColor,
                  ),
                ListTile(
                  leading: SettingsIcons.clearCache(),
                  title: Text(s.clear_cache),
                  onTap: _clearCache,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
