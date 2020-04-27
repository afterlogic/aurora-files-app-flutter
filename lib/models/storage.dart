import 'package:flutter/widgets.dart';

class Storage {
  final String type;
  final String displayName;
  final bool isExternal;
  final int order;
  final bool isDroppable;

  Storage({
    @required this.order,
    @required this.isDroppable,
    @required this.type,
    @required this.displayName,
    @required this.isExternal,
  });

  static Storage fromMap(Map<String, dynamic> rawStorage) {
    return  Storage(
      type: rawStorage["Type"],
      displayName: rawStorage["DisplayName"],
      isExternal: rawStorage["IsExternal"],
      order: rawStorage["Order"],
      isDroppable: rawStorage["IsDroppable"],
    );
  }
}
