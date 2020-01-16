//import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'di/di.dart';
import 'modules/app_screen.dart';

//todo
const useCommonLinkShare = false;

final enablePgp = !(Platform.isIOS && !kDebugMode);

void main() {
  // todo crashlytics
//  if (!kDebugMode) {
//    Crashlytics.instance.enableInDevMode = true;
//    FlutterError.onError = Crashlytics.instance.recordFlutterError;
//  }

  DI.init();
  runApp(App());
}
