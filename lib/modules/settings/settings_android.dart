import 'package:aurora_logger/aurora_logger.dart';
import 'package:aurora_ui_kit/aurora_ui_kit.dart';
import 'package:aurorafiles/build_property.dart';
import 'package:aurorafiles/l10n/l10n.dart';
import 'package:aurorafiles/modules/app_store.dart';
import 'package:aurorafiles/modules/auth/auth_route.dart';
import 'package:aurorafiles/modules/settings/repository/settings_local_storage.dart';
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
  const SettingsAndroid({super.key});

  @override
  _SettingsAndroidState createState() => _SettingsAndroidState();
}

class _SettingsAndroidState extends State<SettingsAndroid> {
  bool showDebug = false;
  bool showEncryption = false;
  final navigatorKey = GlobalKey<SettingsNavigatorState>();
  final loggerStorage = LoggerStorage();
  final _settingsLocal = SettingsLocalStorage();

  @override
  void initState() {
    super.initState();
    _updateShowDebug();
    _updateShowEncryption();
  }

  Future<void> _updateShowDebug() async {
    showDebug = await loggerStorage.getDebugEnable();
    if (mounted) setState(() {});
  }

  Future<void> _updateShowEncryption() async {
    showEncryption = await _settingsLocal.getEncryptExist();
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final s = context.l10n;
    final isTablet = LayoutConfig.of(context).isTablet;
    final current = isTablet
        ? (navigatorKey.currentState?.current.name ?? CommonSettingsRoute.name)
        : null;
    Widget body = ListView(
      children: <Widget>[
        ListTile(
          selected: current == CommonSettingsRoute.name,
          title: Text(s.common),
          leading: const AMCircleIcon(Icons.tune),
          onTap: () => navigator(context).setRoot(CommonSettingsRoute.name),
        ),
        ListTile(
          selected: current == EncryptionServerRoute.name,
          title: Text(s.encryption),
          leading: const AMCircleIcon(MdiIcons.alien),
          onTap: () => navigator(context).setRoot(EncryptionServerRoute.name),
        ),
        if (BuildProperty.pgpEnable)
          ListTile(
            selected: current == PgpSettingsRoute.name,
            title: Text(s.openPGP),
            leading: const AMCircleIcon(MdiIcons.key),
            onTap: () => navigator(context).setRoot(PgpSettingsRoute.name),
          ),
        ListTile(
          selected: current == StorageInfoRoute.name,
          title: Text(s.storage_info),
          leading: const AMCircleIcon(Icons.storage),
          onTap: () => navigator(context).setRoot(StorageInfoRoute.name),
        ),
        ListTile(
          selected: current == AboutRoute.name,
          title: Text(s.about),
          leading: const AMCircleIcon(Icons.info_outline),
          onTap: () => navigator(context).setRoot(AboutRoute.name),
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
            leading: const AMCircleIcon(Icons.perm_device_information),
            title: const Text("Debug"),
            onTap: () => navigator(context).setRoot(LoggerRoute.name),
          ),
        ListTile(
          selected: current == AuthRoute.name,
          leading: const AMCircleIcon(Icons.exit_to_app),
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
                    decoration: const BoxDecoration(
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
              flex: 3,
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

  SettingsNavigator navigator(BuildContext context) {
    final navigator = navigatorKey.currentState;
    return navigator ?? SettingsNavigatorMock(Navigator.of(context));
  }

  Future<void> _exit() async {
    final s = context.l10n;
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
      if (!mounted) return;
      Navigator.pushReplacementNamed(context, AuthRoute.name);
    }
  }
}
