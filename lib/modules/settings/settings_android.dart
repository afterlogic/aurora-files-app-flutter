import 'package:aurora_ui_kit/aurora_ui_kit.dart';
import 'package:aurorafiles/build_property.dart';
import 'package:aurorafiles/example_widget/example_widget.dart';
import 'package:aurorafiles/generated/s_of_context.dart';
import 'package:aurorafiles/modules/app_store.dart';
import 'package:aurorafiles/modules/auth/auth_route.dart';
import 'package:aurorafiles/modules/settings/screens/about/about_route.dart';
import 'package:aurorafiles/modules/settings/screens/common/common_route.dart';
import 'package:aurorafiles/modules/settings/screens/encryption/encryption_route.dart';
import 'package:aurorafiles/modules/settings/screens/encryption_server_setting/encryption_server_route.dart';
import 'package:aurorafiles/modules/settings/screens/pgp/pgp_setting_route.dart';
import 'package:aurorafiles/modules/settings/screens/storage/storage_info_route.dart';
import 'package:aurorafiles/modules/settings/state/settings_state.dart';
import 'package:flutter/foundation.dart';
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
    final authState = AppStore.authState;
    final s = Str.of(context);
    return Provider<SettingsState>(
      create: (_) => AppStore.settingsState,
      child: Scaffold(
        appBar: AMAppBar(
          title: Text(s.settings),
        ),
//        drawer: MainDrawer(),
        body: ListView(
          children: <Widget>[
            ListTile(
              title: Text(s.common),
              leading: AMCircleIcon(Icons.tune),
              onTap: () =>
                  Navigator.pushNamed(context, CommonSettingsRoute.name),
            ),
            ListTile(
              title: Text(s.encryption),
              leading: AMCircleIcon(MdiIcons.alien),
              onTap: () => Navigator.pushNamed(context, EncryptionServerRoute.name),
            ),
            if (BuildProperty.pgpEnable)
              ListTile(
                title: Text(s.openPGP),
                leading: AMCircleIcon(MdiIcons.key),
                onTap: () =>
                    Navigator.pushNamed(context, PgpSettingsRoute.name),
              ),
            ListTile(
              title: Text(s.storage_info),
              leading: AMCircleIcon(Icons.storage),
              onTap: () => Navigator.pushNamed(context, StorageInfoRoute.name),
            ),
            ListTile(
              title: Text(s.about),
              leading: AMCircleIcon(Icons.info_outline),
              onLongPress: kDebugMode ? () => openExample(context) : null,
              onTap: () => Navigator.pushNamed(context, AboutRoute.name),
            ),
            ListTile(
              leading: AMCircleIcon(Icons.exit_to_app),
              title: Text(s.log_out),
              onTap: () async {
                final result = await AMConfirmationDialog.show(
                  context,
                  null,
                  s.confirm_exit,
                  s.exit,
                  s.cancel,
                );
                if (result == true) {
                  authState.onLogout();
                  Navigator.pushReplacementNamed(context, AuthRoute.name);
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
