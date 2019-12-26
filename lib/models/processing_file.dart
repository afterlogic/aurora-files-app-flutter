import 'dart:async';
import 'dart:io';

import 'package:flutter/widgets.dart';

enum ProcessingType {
  upload,
  download,
  share,
  offline,
  cacheImage,
  cacheToDelete,
}

class ProcessingFile {
  final String guid;
  final String name;
  final File fileOnDevice;
  final int size;
  final ProcessingType processingType;
  StreamSubscription subscription; // lateInit
  String ivBase64; // in case of encryption/decryption, otherwise leave null

  double _currentProgress;
  final _controller = StreamController<double>.broadcast();
  double get currentProgress => _currentProgress;
  Stream<double> get progressStream => _controller.stream.asBroadcastStream();

  ProcessingFile({
    @required this.guid,
    @required this.name,
    @required this.fileOnDevice,
    @required this.size,
    @required this.processingType,
    this.ivBase64,
  });

  void updateProgress(double num) {
    if (num > 1.05 || num < 0.0) {
      throw Exception("Progress $num is out of bounds (from 0.0 to 1.05)");
    }
    _currentProgress = num;
    _controller.sink.add(num);
  }

  void endProcess() {
    _controller.close();
    subscription?.cancel();
  }
}
