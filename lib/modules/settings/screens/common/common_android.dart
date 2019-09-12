import 'package:aurorafiles/modules/app_store.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class CommonSettingsAndroid extends StatefulWidget {
  @override
  _CommonSettingsAndroidState createState() => _CommonSettingsAndroidState();
}

class _CommonSettingsAndroidState extends State<CommonSettingsAndroid> {
  final _settingsState = AppStore.settingsState;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
        ],
      ),
    );
  }
}
