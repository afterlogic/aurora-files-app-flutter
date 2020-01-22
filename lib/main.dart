//import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';

import 'di/di.dart';
import 'modules/app_screen.dart';

void main() {
  // todo crashlytics
//  if (!kDebugMode) {
//    Crashlytics.instance.enableInDevMode = true;
//    FlutterError.onError = Crashlytics.instance.recordFlutterError;
//  }

  DI.init();
  runApp(App());
}
