import 'package:aurorafiles/models/recipient.dart';
import 'package:aurorafiles/modules/files/repository/share_access_right.dart';
import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';

class ShareAccessEntry {
  final Recipient recipient;
  final ShareAccessRight right;
  final String id;

  ShareAccessEntry({
    @required this.recipient,
    @required this.right,
    String id,
  }) : id = id ?? Uuid().v4();

  ShareAccessEntry copyWith({ShareAccessRight right}) {
    return ShareAccessEntry(
      recipient: this.recipient,
      right: right ?? this.right,
      id: this.id,
    );
  }
}
