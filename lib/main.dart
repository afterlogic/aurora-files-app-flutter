import 'package:aurorafiles/navigation/routes.dart';
import 'package:aurorafiles/screens/auth/auth_route.dart';
import 'package:aurorafiles/screens/files/files_route.dart';
import 'package:aurorafiles/store/app_state.dart';
import 'package:aurorafiles/themimg/material_theme.dart';
import 'package:flutter/material.dart';

import 'screens/auth/state/auth_state.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: AuthState().initSharedPrefs(),
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
            return CircularProgressIndicator();
          }
        });
  }
}
