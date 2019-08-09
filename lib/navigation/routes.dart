import 'package:aurorafiles/screens/auth/auth_android.dart';
import 'package:aurorafiles/screens/auth/auth_route.dart';
import 'package:aurorafiles/screens/files/files_android.dart';
import 'package:aurorafiles/screens/files/files_route.dart';

final androidRoutes = {
  FilesRoute.name: (context) => FilesAndroid(),
  AuthRoute.name: (context) => AuthAndroid(),
};
