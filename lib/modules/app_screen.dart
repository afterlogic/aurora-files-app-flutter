import 'package:aurorafiles/navigation/routes.dart';
import 'package:aurorafiles/shared_ui/main_gradient.dart';
import 'package:aurorafiles/store/app_state.dart';
import 'package:aurorafiles/themimg/material_theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'auth/auth_route.dart';
import 'auth/state/auth_state.dart';
import 'files/files_route.dart';
import 'settings/state/settings_state.dart';

class App extends StatefulWidget {
  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  final _authState = AuthState();
  final _settingsState = SettingsState();
  Future<bool> _initSharedPrefs;

  @override
  void initState() {
    super.initState();
    _initSharedPrefs = _authState.initSharedPrefs();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<AuthState>(
          builder: (_) => _authState,
          dispose: (_, val) => val.dispose(),
        ),
        Provider<SettingsState>(
          builder: (_) => _settingsState,
          dispose: (_, val) => val.dispose(),
        ),
      ],
      child: FutureBuilder(
          future: _initSharedPrefs,
          builder: (_, AsyncSnapshot<bool> snapshot) {
            if (snapshot.connectionState == ConnectionState.done &&
                snapshot.hasData) {
              return MaterialApp(
                title: SingletonStore.instance.appName,
                theme: AppMaterialTheme.darkTheme,
                darkTheme: AppMaterialTheme.darkTheme,
                onGenerateRoute: onGenerateRoute,
                initialRoute: snapshot.data ? FilesRoute.name : AuthRoute.name,
              );
            } else {
              return Material(child: MainGradient());
            }
          }),

    );
  }
}
