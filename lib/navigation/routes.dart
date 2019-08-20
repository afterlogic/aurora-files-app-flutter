import 'package:aurorafiles/screens/auth/auth_android.dart';
import 'package:aurorafiles/screens/auth/auth_route.dart';
import 'package:aurorafiles/screens/file_viewer/file_viewer_android.dart';
import 'package:aurorafiles/screens/file_viewer/file_viewer_route.dart';
import 'package:aurorafiles/screens/files/files_android.dart';
import 'package:aurorafiles/screens/files/files_route.dart';
import 'package:aurorafiles/shared_ui/fade_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

Route onGenerateRoute(RouteSettings settings) {
  switch (settings.name) {
    case AuthRoute.name:
      return MaterialPageRoute(builder: (context) => AuthAndroid());

    case FilesRoute.name:
      return FadeRoute(page: FilesAndroid());

    case FileViewerRoute.name:
      final FileViewerScreenArguments args = settings.arguments;
      return FadeRoute(
          page: FileViewerAndroid(
        file: args.file,
        filesState: args.filesState,
      ));

    default:
      return MaterialPageRoute(
          builder: (_) => Scaffold(
                body: Center(
                    child: Text('No route defined for ${settings.name}')),
              ));
  }
}
