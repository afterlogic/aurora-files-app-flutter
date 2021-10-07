import 'dart:convert';

import 'package:aurorafiles/models/api_body.dart';
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
      return EncryptionSetting(
        resBody['Result']["EnableModule"] ?? false,
        resBody['Result']["EnableInPersonalStorage"] ?? false,
      );
    } else {
      throw CustomException(getErrMsg(resBody));
    }
  }

  Future setEncryptSetting(EncryptionSetting encryptionSetting) async {
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
}

class EncryptionSetting {
  final bool enable;
  final bool enableInPersonalStorage;

  EncryptionSetting(this.enable, this.enableInPersonalStorage);
}
