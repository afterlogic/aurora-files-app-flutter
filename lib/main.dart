import 'dart:async';

import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'di/di.dart';
import 'logger/logger_view.dart';
import 'modules/app_screen.dart';
import 'override_platform.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  if (!kDebugMode) {
    Crashlytics.instance.enableInDevMode = true;
    FlutterError.onError = Crashlytics.instance.recordFlutterError;
  }

  PlatformOverride.setPlatform(Platform.isIOS);
  DI.init();

  runZoned(() {
    runApp(LoggerView.wrap((App())));
  }, onError: Crashlytics.instance.recordError);
}
