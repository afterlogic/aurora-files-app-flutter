import 'dart:io';

import 'package:aurorafiles/modules/auth/auth_android.dart';
import 'package:aurorafiles/modules/auth/auth_route.dart';
import 'package:aurorafiles/modules/files/files_android.dart';
import 'package:aurorafiles/modules/files/files_route.dart';
import 'package:aurorafiles/modules/files/screens/file_viewer/file_viewer_android.dart';
import 'package:aurorafiles/modules/files/screens/file_viewer/file_viewer_route.dart';
import 'package:aurorafiles/modules/settings/screens/encryption/encryption_android.dart';
import 'package:aurorafiles/modules/settings/screens/encryption/encryption_route.dart';
import 'package:aurorafiles/modules/settings/settings_android.dart';
import 'package:aurorafiles/modules/settings/settings_route.dart';
import 'package:aurorafiles/shared_ui/fade_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class AppNavigation {
  static String _currentRoute = "/";

  static String get currentRoute => _currentRoute;

  static Route onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AuthRoute.name:
        _currentRoute = AuthRoute.name;
        return MaterialPageRoute(builder: (context) => AuthAndroid());

      case FilesRoute.name:
        _currentRoute = FilesRoute.name;
        final FilesScreenArguments args = settings.arguments;
        if (Platform.isIOS) {
          return MaterialPageRoute(
              builder: (context) => args != null
                  ? FilesAndroid(path: args.path)
                  : FilesAndroid());
        } else {
          return FadeRoute(
            page: args != null ? FilesAndroid(path: args.path) : FilesAndroid(),
            duration: 200,
          );
        }
        break;

      case FileViewerRoute.name:
        final FileViewerScreenArguments args = settings.arguments;
        if (Platform.isIOS) {
          return MaterialPageRoute(
              builder: (context) => FileViewerAndroid(
                    file: args.file,
                    filesState: args.filesState,
                    filesPageState: args.filesPageState,
                  ));
        } else {
          return FadeRoute(
              page: FileViewerAndroid(
            file: args.file,
            filesState: args.filesState,
            filesPageState: args.filesPageState,
          ));
        }
        break;

      case SettingsRoute.name:
        if (Platform.isIOS) {
          return MaterialPageRoute(builder: (context) => SettingsAndroid());
        } else {
          return FadeRoute(page: SettingsAndroid(), duration: 150);
        }
        break;

      case EncryptionRoute.name:
        if (Platform.isIOS) {
          return MaterialPageRoute(builder: (context) => EncryptionAndroid());
        } else {
          return FadeRoute(page: EncryptionAndroid(), duration: 150);
        }
        break;

      default:
        _currentRoute = "";
        return MaterialPageRoute(
            builder: (_) => Scaffold(
                  body: Center(
                      child: Text('No route defined for ${settings.name}')),
                ));
    }
  }
}
