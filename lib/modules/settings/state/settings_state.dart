import 'dart:async';
import 'dart:io';

import 'package:aurorafiles/modules/settings/repository/settings_local_storage.dart';
import 'package:aurorafiles/override_platform.dart';
import 'package:aurorafiles/utils/custom_exception.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';
import 'package:moor_flutter/moor_flutter.dart';
import 'package:share_extend/share_extend.dart';

part 'settings_state.g.dart';

class SettingsState = _SettingsState with _$SettingsState;

abstract class _SettingsState with Store {
  final _settingsLocal = SettingsLocalStorage();

  @observable
  ConnectivityResult internetConnection;

  @observable
  bool isDarkTheme;

  @observable
  bool isParanoidEncryptionEnabled = true;

  @observable
  Map<String, String> encryptionKeys = new Map();

  @observable
  String selectedKeyName;

  String get currentKey => encryptionKeys[selectedKeyName];

  Future<bool> getUserEncryptionKeys() async {
    try {
      encryptionKeys = await _settingsLocal.getAllUserKeys();
      if (encryptionKeys.length > 0) {
        final keyNames = encryptionKeys.keys.toList();
        selectedKeyName = keyNames[0];
      } else {
        selectedKeyName = null;
      }
      return true;
    } catch (err) {
      print("getUserEncryptionKeys ERRORR: $err");
      selectedKeyName = null;
      return true;
    }
  }

  Future<bool> getUserSettings() async {
    final connectivity = Connectivity();

    connectivity.onConnectivityChanged.listen((res) {
      internetConnection = res;
      print("internetConnection: $internetConnection");
    });
    final result = await Future.wait([
      _settingsLocal.getDarkThemeFromStorage(),
      connectivity.checkConnectivity(),
    ]);
    if (result[0] != null) isDarkTheme = result[0];
    internetConnection = result[1];
    return true;
  }

  void toggleDarkTheme(bool val) {
    isDarkTheme = val;
    _settingsLocal.setDarkThemeToStorage(val);
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

  Future<void> onImportKeyFromFile(
      {Function() onSuccess, Function(String) onError}) async {
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
      onSuccess();
    } catch (err) {
      print("onImportKeyFromFile error: $err");
      onError(err.toString());
    }
  }

  onShareEncryptionKey() {
    ShareExtend.share(encryptionKeys[selectedKeyName], "text");
  }

  Future<void> onExportEncryptionKey({
    Function(String) onSuccess,
    Function(String) onError,
  }) async {
    String exportedFileDir;
    try {
      final keyName = selectedKeyName;
      exportedFileDir =
          await _settingsLocal.exportKey(keyName, encryptionKeys[keyName]);
      if (exportedFileDir == null) {
        throw CustomException("Unresolved directory");
      } else {
        onSuccess(Platform.isIOS ? null : exportedFileDir);
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
