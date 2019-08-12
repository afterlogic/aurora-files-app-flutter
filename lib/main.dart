import 'package:aurorafiles/navigation/routes.dart';
import 'package:aurorafiles/screens/auth/auth_repository.dart';
import 'package:aurorafiles/screens/auth/auth_route.dart';
import 'package:aurorafiles/screens/file_viewer/file_viewer_android.dart';
import 'package:aurorafiles/screens/file_viewer/file_viewer_route.dart';
import 'package:aurorafiles/screens/files/files_route.dart';
import 'package:aurorafiles/shared_ui/fade_route.dart';
import 'package:aurorafiles/store/app_state.dart';
import 'package:aurorafiles/themimg/material_theme.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: AuthRepository().getTokenFromStorage(),
        builder: (_, AsyncSnapshot<String> snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasData && snapshot.data is String)
              SingletonStore.instance.authToken = snapshot.data;

            return MaterialApp(
              title: 'Aurora.Files',
              theme: AppMaterialTheme.theme,
              darkTheme: AppMaterialTheme.darkTheme,
              onGenerateRoute: onGenerateRoute,
              initialRoute: snapshot.hasData && snapshot.data is String
                  ? FilesRoute.name
                  : AuthRoute.name,
//              routes: androidRoutes,
              debugShowCheckedModeBanner: false,
            );
          } else {
            return CircularProgressIndicator();
          }
        });
  }
}
