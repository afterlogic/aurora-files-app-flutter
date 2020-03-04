import 'package:aurorafiles/generated/s_of_context.dart';
import 'package:aurorafiles/modules/app_store.dart';
import 'package:aurorafiles/shared_ui/confirmation_dialog.dart';
import 'package:aurorafiles/utils/show_snack.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:aurora_ui_kit/aurora_ui_kit.dart';
class CommonSettingsAndroid extends StatefulWidget {
  @override
  _CommonSettingsAndroidState createState() => _CommonSettingsAndroidState();
}

class _CommonSettingsAndroidState extends State<CommonSettingsAndroid> {
  final _settingsState = AppStore.settingsState;
  final scaffoldKey = new GlobalKey<ScaffoldState>();
  S s;

  Future _clearCache() async {
    final result = await ConfirmationDialog.show(
        context,
        s.clear_cache,
        s.confirm_delete,
        s.clear);
    if (result == true) {
      await AppStore.filesState.clearCache(deleteCachedImages: true);
      showSnack(
          context: context,
          scaffoldState: scaffoldKey.currentState,
          isError: false,
          msg: s.cache_cleared_success);
    }
  }

  @override
  Widget build(BuildContext context) {
    s = Str.of(context);
    return Scaffold(
      key: scaffoldKey,
      appBar: AMAppBar(
        title: Text(s.common),
      ),
      body: ListView(
        children: <Widget>[
          Observer(
            builder: (_) => SwitchListTile.adaptive(
              value: _settingsState.isDarkTheme,
              activeColor: Theme.of(context).accentColor,
              onChanged: (bool val) => _settingsState.toggleDarkTheme(val),
              title: ListTile(
                contentPadding: EdgeInsets.zero,
                leading: AMCircleIcon(MdiIcons.themeLightDark),
                title: Text(s.dark_theme),
              ),
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
