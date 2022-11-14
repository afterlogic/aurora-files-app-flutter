import 'dart:io';

import 'package:aurorafiles/build_property.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

class DeviceIdStorage {
  static final _deviceInfo = DeviceInfoPlugin();

  DeviceIdStorage._();

  static Future<String> getDeviceName() async {
    String device;
    if (Platform.isIOS) {
      final info = await _deviceInfo.iosInfo;
      device = "${info.name} ${info.systemName} ${info.systemVersion}";
    } else {
      final info = await _deviceInfo.androidInfo;
      device = '${info.manufacturer} ${info.model}';
    }
    return BuildProperty.appName + " " + device;
  }

  static Future<String> getDeviceId() async {
    ///starting with Android 10, the use of hardware ID is not recommended
    ///so, we use generated UUID
    String? deviceId = await _getDeviceId();
    if (deviceId == null) {
      deviceId = const Uuid().v4();
      await _setDeviceId(deviceId);
    }
    return (kDebugMode ? "DEBUG" : "") + deviceId;
  }

  static const _deviceIdKey = "deviceIdKey";

  static Future<String?> _getDeviceId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(_deviceIdKey);
  }

  static Future<bool> _setDeviceId(String? value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return value == null
        ? prefs.remove(_deviceIdKey)
        : prefs.setString(_deviceIdKey, value);
  }
}
