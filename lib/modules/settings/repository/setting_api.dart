import 'dart:convert';
import 'package:aurorafiles/utils/api_utils.dart';
import 'package:aurorafiles/utils/custom_exception.dart';
import 'package:http/http.dart' as http;
import 'package:aurorafiles/models/api_body.dart';
import 'package:aurorafiles/modules/app_store.dart';

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
        UploadEncryptMode.values[resBody['Result']["EncryptionMode"] as int],
        resBody['Result']["EnableModule"],
      );
    } else {
      throw CustomException(getErrMsg(resBody));
    }
  }

  Future setEncryptSetting(EncryptionSetting encryptionSetting) async {
    final parameters = json.encode({
      "EnableModule": encryptionSetting.enable,
      "EncryptionMode": encryptionSetting.uploadEncryptMode.index,
    });
    final body = ApiBody(
      module: "CoreParanoidEncryptionWebclientPlugin",
      method: "UpdateSettings",
      parameters: parameters,
    );

    final resBody = await sendRequest( body);

    if (resBody['Result'] == true) {
      return;
    } else {
      throw CustomException(getErrMsg(resBody));
    }
  }
}

enum UploadEncryptMode {
  Always,
  Ask,
  Never,
  InEncryptedFolder,
}

class EncryptionSetting {
  final UploadEncryptMode uploadEncryptMode;
  final bool enable;

  EncryptionSetting(this.uploadEncryptMode, this.enable);
}
