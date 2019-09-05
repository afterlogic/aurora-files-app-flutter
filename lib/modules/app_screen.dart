import 'package:aurorafiles/modules/app_navigation.dart';
import 'package:aurorafiles/modules/app_store.dart';
import 'package:aurorafiles/shared_ui/main_gradient.dart';
import 'package:aurorafiles/themimg/material_theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'auth/auth_route.dart';
import 'files/files_route.dart';

class App extends StatefulWidget {
  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  Future<List<bool>> _localStorageInitialization;

  @override
  void initState() {
    super.initState();
    _initLocalStorage();
  }

  Future _initLocalStorage() async {
    _localStorageInitialization = Future.wait([
      AppStore.authState.getAuthSharedPrefs(),
      AppStore.settingsState.getUserEncryptionKeys(),
    ]);
  }

  bool _canEnterMainApp(List<bool> localStorageInitializationResults) {
    bool canEnterMailApp = true;
    localStorageInitializationResults.forEach((result) {
      if (!result) canEnterMailApp = false;
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
            return MaterialApp(
              title: "PrivateMail Files",
              theme: AppMaterialTheme.darkTheme,
              darkTheme: AppMaterialTheme.darkTheme,
              onGenerateRoute: AppNavigation.onGenerateRoute,
              initialRoute: _canEnterMainApp(snapshot.data)
                  ? FilesRoute.name
                  : AuthRoute.name,
            );
          } else {
            return Material(child: MainGradient());
          }
        });
  }
}
