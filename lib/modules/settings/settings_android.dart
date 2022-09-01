import 'package:aurora_logger/aurora_logger.dart';
import 'package:aurora_ui_kit/aurora_ui_kit.dart';
import 'package:aurorafiles/build_property.dart';
import 'package:aurorafiles/generated/s_of_context.dart';
import 'package:aurorafiles/modules/app_store.dart';
import 'package:aurorafiles/modules/auth/auth_route.dart';
import 'package:aurorafiles/modules/settings/screens/about/about_route.dart';
import 'package:aurorafiles/modules/settings/screens/common/common_route.dart';
import 'package:aurorafiles/modules/settings/screens/encryption_server_setting/encryption_server_route.dart';
import 'package:aurorafiles/modules/settings/screens/logger/logger_route.dart';
import 'package:aurorafiles/modules/settings/screens/pgp/pgp_setting_route.dart';
import 'package:aurorafiles/modules/settings/screens/storage/storage_info_route.dart';
import 'package:aurorafiles/modules/settings/state/settings_state.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';
import 'settings_navigator.dart';
import 'package:aurorafiles/shared_ui/layout_config.dart';
import 'package:aurorafiles/modules/app_navigation.dart';

class SettingsAndroid extends StatefulWidget {
  @override
  _SettingsAndroidState createState() => _SettingsAndroidState();
}

class _SettingsAndroidState extends State<SettingsAndroid> {
  bool showDebug = false;
  final navigatorKey = GlobalKey<SettingsNavigatorState>();
  final loggerStorage = LoggerStorage();

  @override
  void initState() {
    super.initState();
    loggerStorage.getDebugEnable().then((value) {
      setState(() => showDebug = value);
    });
  }

  @override
  Widget build(BuildContext context) {
    final isTablet = LayoutConfig.of(context).isTablet;
    final current = isTablet
        ? (navigatorKey.currentState?.current.name ?? CommonSettingsRoute.name)
        : null;
    final s = Str.of(context);
    Widget body = ListView(
      children: <Widget>[
        ListTile(
          selected: current == CommonSettingsRoute.name,
          title: Text(s.common),
          leading: AMCircleIcon(Icons.tune),
          onTap: () => navigator().setRoot(CommonSettingsRoute.name),
        ),
        ListTile(
          selected: current == EncryptionServerRoute.name,
          title: Text(s.encryption),
          leading: AMCircleIcon(MdiIcons.alien),
          onTap: () => navigator().setRoot(EncryptionServerRoute.name),
        ),
        if (BuildProperty.pgpEnable)
          ListTile(
            selected: current == PgpSettingsRoute.name,
            title: Text(s.openPGP),
            leading: AMCircleIcon(MdiIcons.key),
            onTap: () => navigator().setRoot(PgpSettingsRoute.name),
          ),
        ListTile(
          selected: current == StorageInfoRoute.name,
          title: Text(s.storage_info),
          leading: AMCircleIcon(Icons.storage),
          onTap: () => navigator().setRoot(StorageInfoRoute.name),
        ),
        ListTile(
          selected: current == AboutRoute.name,
          title: Text(s.about),
          leading: AMCircleIcon(Icons.info_outline),
          onTap: () => navigator().setRoot(AboutRoute.name),
          onLongPress: BuildProperty.logger
              ? () {
                  loggerStorage.setDebugEnable(true);
                  setState(() => showDebug = true);
                }
              : null,
        ),
        if (showDebug)
          ListTile(
            selected: current == LoggerRoute.name,
            leading: AMCircleIcon(Icons.perm_device_information),
            title: Text("Debug"),
            onTap: () => navigator().setRoot(LoggerRoute.name),
          ),
        ListTile(
          selected: current == AuthRoute.name,
          leading: AMCircleIcon(Icons.exit_to_app),
          title: Text(s.log_out),
          onTap: _exit,
        ),
      ],
    );
    if (isTablet) {
      body = Scaffold(
        appBar: AMAppBar(
          title: Text(s.settings),
        ),
        body: Row(
          children: [
            ClipRRect(
              child: SizedBox(
                width: 304,
                child: Scaffold(
                  body: DecoratedBox(
                    position: DecorationPosition.foreground,
                    decoration: BoxDecoration(
                        border: Border(right: BorderSide(width: 0.2))),
                    child: Drawer(
                      child: ListTileTheme(
                        style: ListTileStyle.drawer,
                        selectedColor: Theme.of(context).colorScheme.secondary,
                        child: SafeArea(child: body),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Flexible(
              child: ClipRRect(
                child: Scaffold(
                  body: SettingsNavigatorWidget(
                    key: navigatorKey,
                    onUpdate: () {
                      setState(() {});
                    },
                    initialRoute: CommonSettingsRoute.name,
                    routeFactory: AppNavigation.onGenerateRoute,
                  ),
                ),
              ),
              flex: 3,
            ),
          ],
        ),
      );
    }
    return Provider<SettingsState>(
        create: (_) => AppStore.settingsState,
        child: Scaffold(
          appBar: isTablet
              ? null
              : AMAppBar(
                  title: Text(s.settings),
                ),
          body: body,
        ));
  }

  SettingsNavigator navigator() {
    final navigator = navigatorKey.currentState;
    return navigator ?? SettingsNavigatorMock(Navigator.of(context));
  }

  _exit() async {
    final s = Str.of(context);
    final authState = AppStore.authState;
    final clearCacheText = s.clear_cache_during_logout;

    final result = await AMOptionalDialog.show(
      context: context,
      title: s.confirm_exit,
      options: {clearCacheText: true},
      actionText: s.exit,
      cancelText: s.cancel,
    );
    if (result is OptionalResult && result.generalResult == true) {
      final clearCache = result.options?[clearCacheText] ?? false;
      authState.onLogout(clearCache);
      Navigator.pushReplacementNamed(context, AuthRoute.name);
    }
  }
}
