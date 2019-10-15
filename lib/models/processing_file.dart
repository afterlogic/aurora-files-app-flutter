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
  Function(double) updateProgressInList;
  Function(double) updateProgressInViewer;
  double progress; // in case a list of files with a load being processed is opened set initialProgress
  StreamSubscription subscription; // lateInit
  String ivBase64; // in case of encryption/decryption, otherwise leave null

  ProcessingFile({
    @required this.guid,
    @required this.name,
    @required this.fileOnDevice,
    @required this.size,
    @required this.processingType,
    this.updateProgressInList,
    this.updateProgressInViewer,
    this.subscription,
    this.ivBase64,
  });

  void updateProgress(double num) {
    if (num > 1.1 || num < 0.0) {
      throw Exception("Progress $num is out of bounds (from 0.0 to 1.0)");
    }

    if (updateProgressInList != null) updateProgressInList(num);
    if (updateProgressInViewer != null) updateProgressInViewer(num);
    progress = num;
  }
}
