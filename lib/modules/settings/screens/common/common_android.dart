import 'package:aurorafiles/modules/app_store.dart';
import 'package:aurorafiles/shared_ui/confirmation_dialog.dart';
import 'package:aurorafiles/utils/show_snack.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class CommonSettingsAndroid extends StatefulWidget {
  @override
  _CommonSettingsAndroidState createState() => _CommonSettingsAndroidState();
}

class _CommonSettingsAndroidState extends State<CommonSettingsAndroid> {
  final _settingsState = AppStore.settingsState;
  final scaffoldKey = new GlobalKey<ScaffoldState>();

  Future _clearCache() async {
    final result = await ConfirmationDialog.show(
        context,
        "Clear cache",
        "Are you sure you want to delete all the cached files and images? This will not affect saved files for offline.",
        "Clear");
    if (result == true) {
      await AppStore.filesState.clearCache(deleteCachedImages: true);
      showSnack(
          context: context,
          scaffoldState: scaffoldKey.currentState,
          isError: false,
          msg: "Cache cleared successfully");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: Text("Common"),
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
                leading: Icon(MdiIcons.themeLightDark),
                title: Text("Dark theme"),
              ),
            ),
          ),
          ListTile(
            leading: Icon(MdiIcons.broom),
            title: Text("Clear cache"),
            onTap: _clearCache,
          ),
        ],
      ),
    );
  }
}
