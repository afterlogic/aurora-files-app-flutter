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
        return FadeRoute(
          page: args != null ? FilesAndroid(path: args.path) : FilesAndroid(),
          duration: 200,
        );

      case FileViewerRoute.name:
        _currentRoute = FileViewerRoute.name;
        final FileViewerScreenArguments args = settings.arguments;
        return FadeRoute(
            page: FileViewerAndroid(
          file: args.file,
          filesState: args.filesState,
          filesPageState: args.filesPageState,
        ));

      case SettingsRoute.name:
        _currentRoute = SettingsRoute.name;
        return MaterialPageRoute(builder: (context) => SettingsAndroid());

      case EncryptionRoute.name:
        _currentRoute = EncryptionRoute.name;
        return MaterialPageRoute(builder: (context) => EncryptionAndroid());

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
