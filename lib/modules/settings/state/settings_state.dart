import 'package:aurorafiles/modules/settings/repository/settings_local_storage.dart';
import 'package:aurorafiles/utils/custom_exception.dart';
import 'package:mobx/mobx.dart';
import 'package:moor_flutter/moor_flutter.dart';

part 'settings_state.g.dart';

class SettingsState = _SettingsState with _$SettingsState;

abstract class _SettingsState with Store {
  final _settingsLocal = SettingsLocalStorage();

  @observable
  bool isParanoidEncryptionEnabled = true;

  @observable
  Map<String, String> encryptionKeys = new Map();

  @observable
  String selectedKeyName;

  String get currentKey => encryptionKeys[selectedKeyName];

  Future<bool> getUserEncryptionKeys() async {
    encryptionKeys = await _settingsLocal.getAllUserKeys();
    if (encryptionKeys.length > 0) {
      final keyNames = encryptionKeys.keys.toList();
      selectedKeyName = keyNames[0];
    } else {
      selectedKeyName = null;
    }
    return true;
  }

  // for both generating and importing from text
  Future<void> onAddKey({
    @required String name,
    String encryptionKey,
    Function(String) onError,
  }) async {
    // if encryptionKey is provided - import as text, else generate new key
    final newKey = encryptionKey == null
        ? _settingsLocal.generateKey().base16
        : encryptionKey;
    try {
      await _settingsLocal.addKey(name, newKey);
    } catch (err) {
      onError(err.toString());
    }
  }

  Future<void> onImportKeyFromFile({Function(String) onError}) async {
    try {
      final Map<String, String> encryptionKeyFromFile =
          await _settingsLocal.importKeyFromFile();
      if (encryptionKeyFromFile == null) return;
      String keyName = encryptionKeyFromFile.keys.toList()[0];
      String keyValue = encryptionKeyFromFile.values.toList()[0];

      if (keyName.endsWith(".txt")) {
        keyName = keyName.substring(0, keyName.length - 4);
      }

      await _settingsLocal.addKey(keyName, keyValue);
      getUserEncryptionKeys();
    } catch (err) {
      print("onImportKeyFromFile error: $err");
      onError(err.toString());
    }
  }

  Future<void> onExportEncryptionKey({
    String name,
    Function(String) onSuccess,
    Function(String) onError,
  }) async {
    String exportedFileDir;
    try {
      final keyName = name == null ? selectedKeyName : name;
      exportedFileDir =
          await _settingsLocal.exportKey(keyName, encryptionKeys[keyName]);
      if (exportedFileDir == null) {
        throw CustomException("Unresolved directory");
      } else {
        onSuccess(exportedFileDir);
      }
    } catch (err) {
      onError(err.toString());
    }
  }

  Future<void> onDeleteEncryptionKey({
    String name,
    Function(String) onError,
  }) async {
    try {
      final keyName = name == null ? selectedKeyName : name;
      return await _settingsLocal.deleteKey(keyName);
    } catch (err) {
      onError(err.toString());
    }
  }
}
