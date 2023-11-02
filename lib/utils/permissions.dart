import 'package:device_info_plus/device_info_plus.dart';
import 'package:permission_handler/permission_handler.dart';

import 'custom_exception.dart';

///make sure you have checked if platform NOT IOS before invoking the function
Future getStoragePermissions() async {
  final deviceInfoPlugin = DeviceInfoPlugin();
  final androidDeviceInfo = await deviceInfoPlugin.androidInfo;
  final sdkVersion = androidDeviceInfo.version.sdkInt;
  if(sdkVersion > 29) return;
  PermissionStatus permission = await Permission.storage.status;
  if (permission != PermissionStatus.granted) {
    permission = await Permission.storage.request();
    if (permission != PermissionStatus.granted) {
      throw CustomException("Access denied");
    }
  }
}
