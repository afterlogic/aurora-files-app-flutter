import 'dart:async';

import 'package:aurora_logger/aurora_logger.dart';
import 'package:aurorafiles/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'di/di.dart';
import 'modules/app_screen.dart';
import 'modules/settings/screens/logger/logger_interceptor_adapter.dart';
import 'override_platform.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  if (!kDebugMode) {
    // FirebaseCrashlytics.instance.enableInDevMode = true;
    FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;
  }
  LoggerSetting.init(LoggerSetting(
    defaultInterceptor: LoggerInterceptorAdapter(),
  ));
  LoggerStorage()
    ..getDebug().then((value) {
      if (value) logger.enable = true;
    })
    ..getIsRun().then((value) {
      if (value) logger.start();
    });

  PlatformOverride.setPlatform(Platform.isIOS);
  DI.init();

  runZonedGuarded<void>(
    () {
      runApp(
        LoggerControllerWidget.wrap(const App()),
      );
    },
    (error, stack) {
      FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    },
  );
}
