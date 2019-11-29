import 'package:domain/api/cache/storage/user_storage_api.dart';
import 'package:domain/api/crypto/key_manager_api.dart';
import 'package:encrypt/encrypt.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class KeyManager implements KeyManagerApi {
  final _storage = FlutterSecureStorage();
  final UserStorageApi _userStorage;

  KeyManager(this._userStorage);

  String _keyPath([String keyName = ""]) =>
      "${_userStorage.userEmail.get()}_$keyName";

  Key _generateKey() => Key.fromSecureRandom(keyLength);

  Future createKey(String keyName) {
    final nameWithOwner = _keyPath(keyName);
    return _storage.write(key: nameWithOwner, value: _generateKey().base16);
  }

  Future addKey(String keyName, String key) {
    final nameWithOwner = _keyPath(keyName);
    return _storage.write(key: nameWithOwner, value: key);
  }

  Future<String> getKey(String keyName) {
    final nameWithOwner = _keyPath(keyName);
    return _storage.read(key: nameWithOwner);
  }

  Future deleteKey(keyName) {
    final nameWithOwner = _keyPath(keyName);
    return _storage.delete(key: nameWithOwner);
  }

  Future<Map<String, String>> getAllKeys() async {
    final encryptionKeys = await _storage.readAll();
    // return key names without owner's prefix
    final Map<String, String> userKeys = new Map();
    encryptionKeys.keys.forEach((nameWithOwner) {
      if (nameWithOwner.startsWith(_keyPath())) {
        // remove owner's email
        final keyName = nameWithOwner.substring(_keyPath().length);
        userKeys[keyName] = encryptionKeys[nameWithOwner];
      }
    });

    return userKeys;
  }

  static const keyLength = 32;
}
