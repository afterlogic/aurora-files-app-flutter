import 'dart:io';

import 'package:aurorafiles/generated/i18n.dart';
import 'package:aurorafiles/modules/app_store.dart';
import 'package:aurorafiles/modules/settings/screens/about/about_route.dart';
import 'package:aurorafiles/modules/settings/screens/common/common_route.dart';
import 'package:aurorafiles/modules/settings/screens/encryption/encryption_route.dart';
import 'package:aurorafiles/modules/settings/screens/pgp/pgp_setting_route.dart';
import 'package:aurorafiles/modules/settings/screens/storage/storage_info_route.dart';
import 'package:aurorafiles/modules/settings/state/settings_state.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';

class SettingsAndroid extends StatefulWidget {
  @override
  _SettingsAndroidState createState() => _SettingsAndroidState();
}

class _SettingsAndroidState extends State<SettingsAndroid> {
  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    return Provider<SettingsState>(
      create: (_) => AppStore.settingsState,
      child: Scaffold(
        appBar: AppBar(
          title: Text(s.settings),
        ),
//        drawer: MainDrawer(),
        body: ListView(
          children: <Widget>[
            ListTile(
              title: Text(s.common),
              leading: Icon(Icons.tune),
              onTap: () =>
                  Navigator.pushNamed(context, CommonSettingsRoute.name),
            ),
            ListTile(
              title: Text(s.encryption),
              leading: Icon(MdiIcons.alien),
              onTap: () => Navigator.pushNamed(context, EncryptionRoute.name),
            ),
            if (!Platform.isIOS)
              ListTile(
                title: Text(s.openPGP),
                leading: Icon(MdiIcons.key),
                onTap: () =>
                    Navigator.pushNamed(context, PgpSettingsRoute.name),
              ),
            ListTile(
              title: Text(s.storage_info),
              leading: Icon(Icons.storage),
              onTap: () => Navigator.pushNamed(context, StorageInfoRoute.name),
            ),
            ListTile(
              title: Text(s.about),
              leading: Icon(Icons.info_outline),
              onTap: () => Navigator.pushNamed(context, AboutRoute.name),
            ),
          ],
        ),
      ),
    );
  }
}
