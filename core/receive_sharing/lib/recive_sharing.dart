import 'dart:async';
import 'dart:convert';

import 'package:flutter/services.dart';

class ReceiveSharing {
  static const MethodChannel _mChannel =
      const MethodChannel('receive_sharing/messages');

  static const EventChannel _eChannelMedia =
      const EventChannel("receive_sharing/events-media");

  static Stream<List<SharedMediaFile>> _streamMedia;

  static Future<List<SharedMediaFile>> getInitialMedia() async {
    final String json = await _mChannel.invokeMethod('getInitialMedia');
    if (json == null) return null;
    final encoded = jsonDecode(json);
    return encoded
        .map<SharedMediaFile>((file) => SharedMediaFile.fromJson(file))
        .toList();
  }

  static Stream<List<SharedMediaFile>> getMediaStream() {
    if (_streamMedia == null) {
      final stream =
          _eChannelMedia.receiveBroadcastStream("media").cast<String>();
      _streamMedia = stream.transform<List<SharedMediaFile>>(
        new StreamTransformer<String, List<SharedMediaFile>>.fromHandlers(
          handleData: (String data, EventSink<List<SharedMediaFile>> sink) {
            if (data == null) {
              sink.add(null);
            } else {
              final encoded = jsonDecode(data);
              sink.add(encoded
                  .map<SharedMediaFile>(
                      (file) => SharedMediaFile.fromJson(file))
                  .toList());
            }
          },
        ),
      );
    }
    return _streamMedia;
  }

  static void reset() {
    _mChannel.invokeMethod('reset').then((_) {});
  }
}

class SharedMediaFile {
  final String path;

  final String name;

  final String text;

  final SharedMediaType type;

  SharedMediaFile(this.name, this.path, this.type, this.text);

  SharedMediaFile.fromJson(Map<String, dynamic> json)
      : name = json["name"],
        path = json['path'],
        text = json['text'],
        type = SharedMediaType.values[json['type']];

  bool get isText => text != null;
}

enum SharedMediaType { Video, Image, Text, Any }
