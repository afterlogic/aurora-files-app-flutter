import 'dart:async';
import 'dart:io';

import 'package:aurorafiles/build_property.dart';
import 'package:aurorafiles/models/server_settings.dart';
import 'package:aurorafiles/modules/settings/repository/setting_api.dart';
import 'package:aurorafiles/modules/settings/repository/settings_local_storage.dart';
import 'package:aurorafiles/utils/custom_exception.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';
import 'package:share_plus/share_plus.dart';

part 'settings_state.g.dart';

class SettingsState = _SettingsState with _$SettingsState;

abstract class _SettingsState with Store {
  final _settingsLocal = SettingsLocalStorage();
  final settingApi = SettingApi();

  @observable
  ConnectivityResult? internetConnection;

  @observable
  bool? isDarkTheme;

  @observable
  bool isParanoidEncryptionEnabled = true;

  @observable
  Map<String, String> encryptionKeys = {};

  @observable
  String? selectedKeyName;

  ServerSettings _serverSettings = ServerSettings();

  bool get isTeamSharingEnable =>
      BuildProperty.teamSharingEnable &&
      _serverSettings.isModuleEnable("SharedFiles");

  String? get currentKey => encryptionKeys[selectedKeyName];

  Future<bool> getUserEncryptionKeys() async {
    try {
      encryptionKeys = await _settingsLocal.getAllUserKeys();
      if (encryptionKeys.isNotEmpty) {
        final keyNames = encryptionKeys.keys.toList();
        selectedKeyName = keyNames[0];
      } else {
        selectedKeyName = null;
      }
      return true;
    } catch (err) {
      print("getUserEncryptionKeys ERROR: $err");
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
    isDarkTheme = result[0] as bool?;
    internetConnection = result[1] as ConnectivityResult;
    return true;
  }

  void toggleDarkTheme(bool? val) {
    isDarkTheme = val;
    _settingsLocal.setDarkThemeToStorage(val);
  }

  // for both generating and importing from text
  Future<void> onAddKey({
    required String name,
    String? encryptionKey,
    required Function(String) onError,
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

  Future<void> onImportKeyFromFile({
    required Function() onSuccess,
    required Function(String) onError,
  }) async {
    try {
      final encryptionKeyFromFile = await _settingsLocal.importKeyFromFile();
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

  void onShareEncryptionKey(Rect rect) {
    Share.share(
      encryptionKeys[selectedKeyName] ?? '',
      subject: selectedKeyName,
      sharePositionOrigin: rect,
    );
  }

  Future<void> onExportEncryptionKey({
    required Function(String?) onSuccess,
    required Function(String) onError,
  }) async {
    String? exportedFileDir;
    try {
      final keyName = selectedKeyName;
      exportedFileDir = await _settingsLocal.exportKey(
        keyName ?? '',
        encryptionKeys[keyName] ?? '',
      );
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
    String? name,
    Function(String)? onError,
  }) async {
    try {
      final keyName = name == null ? selectedKeyName : name;
      return await _settingsLocal.deleteKey(keyName);
    } catch (err) {
      if (onError != null) onError('$err');
    }
  }

  Future<void> updateEncryptionSettings() async {
    EncryptionSetting? setting;
    try {
      setting = await settingApi.getEncryptSetting();
      await _settingsLocal.setEncryptExist(setting.exist);
      await _settingsLocal.setEncryptEnable(setting.enable);
      await _settingsLocal
          .setEncryptInPersonalStorage(setting.enableInPersonalStorage);
    } catch (err) {
      print("getEncryptSetting ERROR: $err");
      await _settingsLocal.setEncryptExist(false);
      await _settingsLocal.setEncryptEnable(false);
      await _settingsLocal.setEncryptInPersonalStorage(false);
    }
  }

  Future<EncryptionSetting> getEncryptionSetting() async {
    return EncryptionSetting(
      exist: await _settingsLocal.getEncryptExist(),
      enable: await _settingsLocal.getEncryptEnable(),
      enableInPersonalStorage:
          await _settingsLocal.getEncryptInPersonalStorage(),
    );
  }

  Future<void> setEncryptionSetting(EncryptionSetting setting) async {
    await settingApi.setEncryptSetting(setting);
    await _settingsLocal.setEncryptEnable(setting.enable);
    await _settingsLocal
        .setEncryptInPersonalStorage(setting.enableInPersonalStorage);
  }

  Future<void> updateAppData() async {
    try {
      _serverSettings = await settingApi.getServerSettings();
    } catch (err) {
      print("getAppData ERROR: $err");
    }
  }

  bool isMethodEnable(String module, String method) {
    return _serverSettings.isMethodEnable(module, method);
  }
}
