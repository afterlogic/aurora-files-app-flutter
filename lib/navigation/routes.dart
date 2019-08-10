import 'package:aurorafiles/screens/auth/auth_android.dart';
import 'package:aurorafiles/screens/auth/auth_route.dart';
import 'package:aurorafiles/screens/file_viewer/file_viewer_android.dart';
import 'package:aurorafiles/screens/file_viewer/file_viewer_route.dart';
import 'package:aurorafiles/screens/files/files_android.dart';
import 'package:aurorafiles/screens/files/files_route.dart';

final androidRoutes = {
  AuthRoute.name: (context) => AuthAndroid(),
  FilesRoute.name: (context) => FilesAndroid(),
  FileViewerRoute.name: (context) => FileViewerAndroid(),
};
