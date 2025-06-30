class Storage {
  final StorageType type;
  final String displayName;
  final bool isExternal;
  final int order;
  final bool isDroppable;

  Storage({
    required this.type,
    required this.displayName,
    required this.isExternal,
    required this.order,
    required this.isDroppable,
  });

  static Storage fromMap(Map<String, dynamic> rawStorage) {
    return Storage(
      type: StorageTypeHelper.toEnum(rawStorage["Type"]),
      displayName: rawStorage["DisplayName"],
      isExternal: rawStorage["IsExternal"],
      order: rawStorage["Order"],
      isDroppable: rawStorage["IsDroppable"],
    );
  }
}

enum StorageType {
  encrypted,
  shared,
  personal,
  corporate,
  favorite,
  trash,
}

class StorageTypeHelper {
  static StorageType toEnum(String name) {
    switch (name) {
      case 'encrypted':
        return StorageType.encrypted;
      case 'shared':
        return StorageType.shared;
      case 'personal':
        return StorageType.personal;
      case 'corporate':
        return StorageType.corporate;
      case 'favorite':
      case 'favorites':
        return StorageType.favorite;
      case 'trash':
        return StorageType.trash;
      default:
        return StorageType.personal;
    }
  }

  static String toName(StorageType type) {
    return type.toString().split('.').last;
  }
}
