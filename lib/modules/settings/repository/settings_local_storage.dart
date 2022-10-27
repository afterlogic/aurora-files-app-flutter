import 'dart:io';

import 'package:aurorafiles/modules/app_store.dart';
import 'package:aurorafiles/utils/custom_exception.dart';
import 'package:aurorafiles/utils/download_directory.dart';
import 'package:aurorafiles/utils/file_utils.dart';
import 'package:aurorafiles/utils/permissions.dart';
import 'package:encrypt/encrypt.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsLocalStorage {
  final secureStorage = const FlutterSecureStorage();

  String _getNameWithOwner([String keyName = ""]) =>
      "${AppStore.authState.userEmail}_$keyName";

  Key generateKey() => Key.fromSecureRandom(32);

  Future<String?> exportKey(String keyName, String encryptionKey) async {
    if (Platform.isIOS) {
      return null;
    }
    await getStoragePermissions();
    Directory dir = await getDownloadDirectory();
    if (!dir.existsSync()) dir = await getApplicationDocumentsDirectory();
    if (!dir.existsSync()) {
      throw CustomException("Could not resolve save directory");
    }

    final formattedKeyName = keyName.replaceAll("/", "").replaceAll(" ", "_");

    final String filePath = dir.path +
        (dir.path.endsWith("/") ? "" : "/") +
        "$formattedKeyName key.txt";

    final exportedTextFile = File(filePath);
    await exportedTextFile.create(recursive: true);
    await exportedTextFile.writeAsString(encryptionKey);

    return filePath;
  }

  // Encryption Keys are stored as Map<OwnerEmail_KeyName, KeyInBase16>
  Future<void> addKey(String keyName, String key) {
    final nameWithOwner = _getNameWithOwner(keyName);
    return secureStorage.write(key: nameWithOwner, value: key);
  }

  Future<Map<String, String>?> importKeyFromFile() async {
    final result = await FilePicker.platform.pickFiles();
    if (result == null) return null;
    final path = result.files.first.path;
    if (path == null) return null;
    final fileWithKey = File(path);
    final String contents = await fileWithKey.readAsString();
    final fileName = FileUtils.getFileNameFromPath(fileWithKey.path);
    return {fileName: contents};
  }

  Future<String?> getKey(String keyName) {
    final nameWithOwner = _getNameWithOwner(keyName);
    return secureStorage.read(key: nameWithOwner);
  }

  // returns only owner's keys
  Future<Map<String, String>> getAllUserKeys() async {
    final encryptionKeys = await secureStorage.readAll();
    // return key names without owner's prefix
    final Map<String, String> userKeys = {};
    encryptionKeys.keys.forEach((nameWithOwner) {
      if (nameWithOwner.startsWith(_getNameWithOwner()) &&
          !nameWithOwner.endsWith("false") &&
          !nameWithOwner.endsWith("true")) {
        // remove owner's email
        final keyName = nameWithOwner.substring(_getNameWithOwner().length);
        userKeys[keyName] = encryptionKeys[nameWithOwner] ?? '';
      }
    });

    return userKeys;
  }

  Future<void> deleteKey(keyName) {
    final nameWithOwner = _getNameWithOwner(keyName);
    return secureStorage.delete(key: nameWithOwner);
  }

  Future<bool> getDarkThemeFromStorage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool("isDarkThemeEnabled") ?? false;
  }

  Future<bool> setDarkThemeToStorage(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setBool("isDarkThemeEnabled", value);
  }

  Future<bool> getEncryptEnable() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool("EncryptEnable") ?? false;
  }

  Future<void> setEncryptEnable(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool("EncryptEnable", value);
  }

  Future<bool> getEncryptInPersonalStorage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool("EncryptPersonalStorage") ?? false;
  }

  Future<void> setEncryptInPersonalStorage(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool("EncryptPersonalStorage", value);
  }
}
