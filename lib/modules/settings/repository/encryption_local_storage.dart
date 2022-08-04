import 'package:shared_preferences/shared_preferences.dart';

class EncryptionLocalStorage {
  EncryptionLocalStorage._();

  static final instance = EncryptionLocalStorage._();
  static const storePassword = "storePassword";
  static String? _memoryPassword;
  static int? _lastAccess;
  static int _accessDuration = Duration(hours: 1).inMilliseconds;

  static set memoryPassword(v) {
    _lastAccess = DateTime.now().millisecondsSinceEpoch;
    _memoryPassword = v;
  }

  static String? get memoryPassword {
    final now = DateTime.now().millisecondsSinceEpoch;
    if (now - (_lastAccess ?? now) > _accessDuration) {
      _memoryPassword = null;
    }
    _lastAccess = now;
    return _memoryPassword;
  }

  Future<bool> getStorePasswordStorage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(storePassword) ?? false;
  }

  Future<bool> setStorePasswordStorage(bool value) async {
    if (value == false) {
      _memoryPassword = null;
    }
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setBool(storePassword, value);
  }
}
