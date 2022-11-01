import 'package:permission_handler/permission_handler.dart';

import 'custom_exception.dart';

Future getStoragePermissions() async {
  PermissionStatus permission = await Permission.storage.status;
  if (permission != PermissionStatus.granted) {
    permission = await Permission.storage.request();
    if (permission != PermissionStatus.granted) {
      throw CustomException("Access denied");
    }
  }
}
