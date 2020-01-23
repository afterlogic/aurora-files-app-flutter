import 'dart:io';

import 'package:flutter/services.dart';

final _channel = MethodChannel("DIRECTORY_DOWNLOADS");

Future<Directory> getDownloadDirectory() async {
  final path = await _channel.invokeMethod("");
  return Directory(path);
}
