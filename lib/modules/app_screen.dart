import 'dart:async';

import 'package:aurorafiles/generated/i18n.dart';
import 'package:aurorafiles/modules/app_navigation.dart';
import 'package:aurorafiles/modules/app_store.dart';
import 'package:aurorafiles/shared_ui/main_gradient.dart';
import 'package:aurorafiles/themimg/material_theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

import 'auth/auth_route.dart';
import 'files/files_route.dart';

class App extends StatefulWidget {
  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  final _authState = AppStore.authState;
  final _settingsState = AppStore.settingsState;

  Future<List<bool>> _localStorageInitialization;

  @override
  void initState() {
    throw "jopka";
    super.initState();
    _initLocalStorage();
  }

  Future _initLocalStorage() async {
    _localStorageInitialization = Future.wait([
      _authState.getAuthSharedPrefs(),
      _settingsState.getUserEncryptionKeys(),
      _settingsState.getUserSettings(),
    ]);
  }

  bool _canEnterMainApp(List<bool> localStorageInitializationResults) {
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
            return Observer(
              builder: (_) => MaterialApp(
                title: "PrivateMail Files",
                theme: _settingsState.isDarkTheme == true
                    ? AppMaterialTheme.darkTheme
                    : AppMaterialTheme.theme,
                onGenerateRoute: AppNavigation.onGenerateRoute,
                localizationsDelegates: [
                  GlobalMaterialLocalizations.delegate,
                  GlobalWidgetsLocalizations.delegate,
                  GlobalCupertinoLocalizations.delegate,
                  S.delegate,
                ],
                supportedLocales: S.delegate.supportedLocales,
                localeResolutionCallback: S.delegate.resolution(
                    fallback: new Locale("en", ""), withCountry: false),
                initialRoute: _canEnterMainApp(snapshot.data)
                    ? FilesRoute.name
                    : AuthRoute.name,
              ),
            );
          } else if (snapshot.hasError) {
            final err = snapshot.error.toString();
            return Material(
                child: Center(
                    child: SelectableText(
                        "Could not start the app, please make a screenshot of the error and send it to support@afterlogic.com and we'll fix it!\nERROR: $err")));
          } else {
            return Material(child: MainGradient());
          }
        });
  }
}
