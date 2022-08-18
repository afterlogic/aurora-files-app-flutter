import 'dart:convert';

import 'package:aurorafiles/models/api_body.dart';
import 'package:aurorafiles/utils/api_utils.dart';
import 'package:aurorafiles/utils/custom_exception.dart';
import 'package:flutter/foundation.dart';

class SettingApi {
  Future<EncryptionSetting> getEncryptSetting() async {
    final body = ApiBody(
      module: "CoreParanoidEncryptionWebclientPlugin",
      method: "GetSettings",
      parameters: "",
    );

    final resBody = await sendRequest(body);

    if (resBody['Result'] != null) {
      return EncryptionSetting(
        exist: true,
        enable: resBody['Result']["EnableModule"] ?? false,
        enableInPersonalStorage: resBody['Result']["EnableInPersonalStorage"] ?? false,
      );
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

  Future<AppData> getAppData() async {
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
      final appData = AppData(
        availableClientModules: modules,
      );
      return appData;
    } else {
      throw CustomException(getErrMsg(resBody));
    }
  }
}

class EncryptionSetting {
  final bool exist;
  final bool enable;
  final bool enableInPersonalStorage;

  EncryptionSetting({
    @required this.exist,
    @required this.enable,
    @required this.enableInPersonalStorage,
  });
}

class AppData {
  final List<String> availableClientModules;

  AppData({@required this.availableClientModules});
}
