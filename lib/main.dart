import 'package:flutter/material.dart';

import 'di/di.dart';
import 'modules/app_screen.dart';

void main() {
  DI.init();
  runApp(App());
}
