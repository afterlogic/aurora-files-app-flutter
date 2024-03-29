import 'dart:async';

import 'package:aurora_logger/aurora_logger.dart';
import 'package:aurorafiles/build_property.dart';
import 'package:aurorafiles/l10n/l10n.dart';
import 'package:aurorafiles/http/interceptor.dart';
import 'package:aurorafiles/modules/app_navigation.dart';
import 'package:aurorafiles/modules/app_store.dart';
import 'package:aurorafiles/shared_ui/aurora_snack_bar.dart';
import 'package:aurorafiles/shared_ui/main_gradient.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:theme/app_theme.dart';

import 'auth/auth_route.dart';
import 'files/files_route.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  final _authState = AppStore.authState;
  final _settingsState = AppStore.settingsState;
  late Future<List<bool>> _localStorageInitialization;
  final _navigatorKey = GlobalKey<NavigatorState>();
  final _scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();

  @override
  void initState() {
    super.initState();
    WebMailApi.onLogout = onLogout;
    WebMailApi.isMethodEnable = _settingsState.isMethodEnable;
    _initLocalStorage();
    _initSnackBar();
  }

  @override
  void dispose() {
    if (WebMailApi.onLogout == onLogout) {
      WebMailApi.onLogout = null;
    }
    super.dispose();
  }

  void onLogout() {
    _authState.onLogout();
    _navigatorKey.currentState?.pushReplacementNamed(AuthRoute.name);
  }

  Future<void> _initLocalStorage() async {
    _localStorageInitialization = Future.wait([
      _authState.getAuthSharedPrefs(),
      _settingsState.getUserEncryptionKeys(),
      _settingsState.getUserSettings(),
    ]);
  }

  void _initSnackBar() {
    AuroraSnackBar.init(
      scaffoldMessengerKey: _scaffoldMessengerKey,
      settingsState: _settingsState,
    );
  }

  Future<void> _updateAppSettings() async {
    _settingsState.updateAppData();
  }

  ThemeData? _getTheme(bool? isDarkTheme) {
    if (isDarkTheme == false) {
      return AppTheme.light;
    } else if (isDarkTheme == true) {
      return AppTheme.dark;
    } else {
      return null;
    }
  }

  bool _canEnterMainApp(List<bool?>? localStorageInitializationResults) {
    if (localStorageInitializationResults == null) return false;
    bool canEnterMailApp = true;
    localStorageInitializationResults.forEach((result) {
      if (result == null || result == false) canEnterMailApp = false;
    });
    return canEnterMailApp;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _localStorageInitialization,
        builder: (_, AsyncSnapshot<List<bool>> snapshot) {
          if (snapshot.connectionState == ConnectionState.done &&
              snapshot.hasData) {
            _updateAppSettings();
            return LoggerControllerWidget.wrap(
                Observer(
              builder: (_) {
                final theme = _getTheme(_settingsState.isDarkTheme);
                return MaterialApp(
                  navigatorKey: _navigatorKey,
                  scaffoldMessengerKey: _scaffoldMessengerKey,
                  debugShowCheckedModeBanner: false,
                  title: BuildProperty.appName,
                  theme: theme ?? AppTheme.light,
                  darkTheme: theme ?? AppTheme.dark,
                  onGenerateRoute: AppNavigation.onGenerateRoute,
                  localizationsDelegates:
                      AppLocalizations.localizationsDelegates,
                  supportedLocales: AppLocalizations.supportedLocales,
                  initialRoute: _canEnterMainApp(snapshot.data)
                      ? FilesRoute.name
                      : AuthRoute.name,
                );
              },
                ),
            );
          } else if (snapshot.hasError) {
            final err = snapshot.error.toString();
            return Material(
                child: Center(
                    child: SelectableText(
                        "Could not start the app, please make a screenshot of the error and send it to support@afterlogic.com and we'll fix it!\nERROR: $err")));
          } else {
            return const Material(
              child: LoginGradient(),
            );
          }
        });
  }
}
