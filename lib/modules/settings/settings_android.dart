import 'package:aurorafiles/modules/settings/screens/encryption/encryption_route.dart';
import 'package:aurorafiles/shared_ui/main_drawer.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class SettingsAndroid extends StatefulWidget {
  @override
  _SettingsAndroidState createState() => _SettingsAndroidState();
}

class _SettingsAndroidState extends State<SettingsAndroid> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Settings"),
      ),
      drawer: MainDrawer(),
      body: ListView(
        children: <Widget>[
          ListTile(
            title: Text("Common"),
            leading: Icon(Icons.tune),
            onTap: () {},
          ),
          ListTile(
            title: Text("Encryption"),
            leading: Icon(MdiIcons.alien),
            onTap: () => Navigator.pushNamed(context, EncryptionRoute.name),
          ),
        ],
      ),
    );
  }
}
