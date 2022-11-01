import 'dart:convert';

import 'package:aurorafiles/models/api_body.dart';
import 'package:aurorafiles/models/server_settings.dart';
import 'package:aurorafiles/utils/api_utils.dart';
import 'package:aurorafiles/utils/custom_exception.dart';

class SettingApi {
  Future<EncryptionSetting> getEncryptSetting() async {
    final body = ApiBody(
      module: "CoreParanoidEncryptionWebclientPlugin",
      method: "GetSettings",
      parameters: "",
    );

    final resBody = await sendRequest(body);

    if (resBody['Result'] != null) {
      if (resBody['Result'] is Map) {
        return EncryptionSetting(
          exist: true,
          enable: resBody['Result']["EnableModule"] ?? false,
          enableInPersonalStorage:
              resBody['Result']["EnableInPersonalStorage"] ?? false,
        );
      } else {
        return EncryptionSetting(
          exist: false,
          enable: false,
          enableInPersonalStorage: false,
        );
      }
    } else {
      throw CustomException(getErrMsg(resBody));
    }
  }

  Future<void> setEncryptSetting(EncryptionSetting encryptionSetting) async {
    final parameters = json.encode({
      "EnableModule": encryptionSetting.enable,
      "EnableInPersonalStorage": encryptionSetting.enableInPersonalStorage,
    });
    final body = ApiBody(
      module: "CoreParanoidEncryptionWebclientPlugin",
      method: "UpdateSettings",
      parameters: parameters,
    );

    final resBody = await sendRequest(body);

    if (resBody['Result'] == true) {
      return;
    } else {
      throw CustomException(getErrMsg(resBody));
    }
  }

  Future<ServerSettings> getServerSettings() async {
    final body = ApiBody(
      module: "Core",
      method: "GetAppData",
    );
    final resBody = await sendRequest(body);
    final result = resBody['Result'];
    if (result != null) {
      final modules = (result['Core']['AvailableClientModules'] as List)
          .map((e) => e as String)
          .toList();
      final backendModules = (result['Core']['AvailableBackendModules'] as List)
          .map((e) => e as String)
          .toList();
      modules.addAll(backendModules);
      modules.sort();

      final Map<String, dynamic> settings = {};
      modules.forEach((name) {
        settings[name] = result[name];
      });
      final serverSettings = ServerSettings(
        availableModules: modules,
        modulesSettings: settings,
      );
      return serverSettings;
    } else {
      final msg = getErrMsg(resBody);
      throw CustomException(msg);
    }
  }
}

class EncryptionSetting {
  final bool exist;
  final bool enable;
  final bool enableInPersonalStorage;

  EncryptionSetting({
    required this.exist,
    required this.enable,
    required this.enableInPersonalStorage,
  });
}
