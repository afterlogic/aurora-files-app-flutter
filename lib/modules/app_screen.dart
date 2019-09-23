import 'dart:async';

import 'package:aurorafiles/modules/app_navigation.dart';
import 'package:aurorafiles/modules/app_store.dart';
import 'package:aurorafiles/shared_ui/main_gradient.dart';
import 'package:aurorafiles/themimg/material_theme.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
  final _filesState = AppStore.filesState;

  Future<List<bool>> _localStorageInitialization;

  @override
  void initState() {
    super.initState();
    _initLocalStorage();
  }

  Future _initLocalStorage() async {
    final connectivity = Connectivity();
    final connection = await connectivity.checkConnectivity();
    _filesState.isOfflineMode = connection == ConnectivityResult.none;
    _settingsState.internetConnection = connection;
    connectivity.onConnectivityChanged.listen((res) {
      print("internetConnection: ${res}");
      _settingsState.internetConnection = res;
    });
    _localStorageInitialization = Future.wait([
      _authState.getAuthSharedPrefs(),
      _settingsState.getUserEncryptionKeys(),
      _settingsState.getUserSettings(),
    ]);
  }

  bool _canEnterMainApp(List<bool> localStorageInitializationResults) {
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
                theme: _settingsState.isDarkTheme
                    ? AppMaterialTheme.darkTheme
                    : AppMaterialTheme.theme,
                onGenerateRoute: AppNavigation.onGenerateRoute,
                initialRoute: _canEnterMainApp(snapshot.data)
                    ? FilesRoute.name
                    : AuthRoute.name,
              ),
            );
          } else {
            return Material(child: MainGradient());
          }
        });
  }
}
