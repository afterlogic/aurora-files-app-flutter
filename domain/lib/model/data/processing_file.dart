import 'dart:async';
import 'dart:io';

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
  String ivBase64;
  final ProcessingType processingType;
  StreamSubscription subscription;

  double _currentProgress;
  final _controller = StreamController<double>.broadcast();

  double get currentProgress => _currentProgress;

  Stream<double> get progressStream => _controller.stream.asBroadcastStream();

  ProcessingFile(
    this.guid,
    this.name,
    this.fileOnDevice,
    this.size,
    this.processingType,
    this.ivBase64,
  );

  ProcessingFile.fill({
    this.guid,
    this.name,
    this.fileOnDevice,
    this.size,
    this.processingType,
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
