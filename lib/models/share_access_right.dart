enum ShareAccessRight {
  read,
  readWrite,
  readWriteReshare,
  noAccess,
}

class ShareAccessRightHelper {
  static String toName(ShareAccessRight right) {
    switch (right) {
      case ShareAccessRight.read:
        return 'read';
      case ShareAccessRight.readWrite:
        return 'read/write';
      case ShareAccessRight.readWriteReshare:
        return 'read/write/reshare';
      case ShareAccessRight.noAccess:
        return 'no access';
    }
    return '';
  }

  static String toShortName(ShareAccessRight right) {
    switch (right) {
      case ShareAccessRight.read:
        return 'read';
      case ShareAccessRight.readWrite:
        return 'r/w';
      case ShareAccessRight.readWriteReshare:
        return 'r/w/sh';
      case ShareAccessRight.noAccess:
        return 'no';
    }
    return '';
  }

  static int toCode(ShareAccessRight right) {
    switch (right) {
      case ShareAccessRight.read:
        return 2;
      case ShareAccessRight.readWrite:
        return 1;
      case ShareAccessRight.readWriteReshare:
        return 3;
      case ShareAccessRight.noAccess:
        return 0;
    }
    return -1;
  }

  static ShareAccessRight fromCode(int code) {
    switch (code) {
      case 2:
        return ShareAccessRight.read;
      case 1:
        return ShareAccessRight.readWrite;
      case 3:
        return ShareAccessRight.readWriteReshare;
      case 0:
        return ShareAccessRight.noAccess;
      default:
        return null;
    }
  }
}
