import 'package:flutter/material.dart';

import 'di/di.dart';
import 'modules/app_screen.dart';

void main() async {
  await DI.init();
  runApp(App());
}
