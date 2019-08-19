import 'package:flutter/widgets.dart';

class Storage {
  final String type;
  final String displayName;
  final bool isExternal;

  Storage({
    @required this.type,
    @required this.displayName,
    @required this.isExternal,
  });

  static Storage fromMap(Map<String, dynamic> rawStorage) {
    return new Storage(
      type: rawStorage["Type"],
      displayName: rawStorage["DisplayName"],
      isExternal: rawStorage["IsExternal"],
    );
  }
}
