class PlatformOverride {
  static late String _operatingSystem;

  static setPlatform(bool isIOS) {
    if (isIOS) {
      _operatingSystem = "ios";
    } else {
      _operatingSystem = "android";
    }
  }

  static bool get isLinux => (_operatingSystem == "linux");

  static bool get isMacOS => (_operatingSystem == "macos");

  static bool get isWindows => (_operatingSystem == "windows");

  static bool get isAndroid => (_operatingSystem == "android");

  static bool get isIOS => (_operatingSystem == "ios");

  static bool get isFuchsia => (_operatingSystem == "fuchsia");
}
