//import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'dart:io';

import 'package:flutter/material.dart';

import 'di/di.dart';
import 'modules/app_screen.dart';
import 'override_platform.dart';

void main() {
  // todo crashlytics
//  if (!kDebugMode) {
//    Crashlytics.instance.enableInDevMode = true;
//    FlutterError.onError = Crashlytics.instance.recordFlutterError;
//  }
  PlatformOverride.setPlatform(Platform.isIOS);
  DI.init();
  runApp(App());
}
