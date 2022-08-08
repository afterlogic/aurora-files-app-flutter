import 'dart:io';

import 'package:aurorafiles/build_property.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';

class DeviceIdStorage {
  static DeviceInfoPlugin _deviceInfo = DeviceInfoPlugin();

  DeviceIdStorage._();

  static Future<String> getDeviceName() async {
    String device;
    if (Platform.isIOS) {
      final info = await _deviceInfo.iosInfo;
      device = "${info.name} ${info.systemName} ${info.systemVersion}";
    } else {
      device = (await _deviceInfo.androidInfo).model ?? '';
    }
    return BuildProperty.appName + " " + device;
  }

  static Future<String> getDeviceId() async {
    if (Platform.isIOS) {
      final iosInfo = await _deviceInfo.iosInfo;
      return (kDebugMode ? "DEBUG" : "") + (iosInfo.identifierForVendor ?? '');
    } else if (Platform.isAndroid) {
      final androidInfo = await _deviceInfo.androidInfo;
      return (kDebugMode ? "DEBUG" : "") + (androidInfo.androidId ?? '');
    } else {
      return '';
    }
  }
}
