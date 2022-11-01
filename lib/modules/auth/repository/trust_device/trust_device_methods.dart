import 'package:aurorafiles/modules/app_store.dart';
import 'package:aurorafiles/modules/auth/repository/auth_api.dart';
import 'package:aurorafiles/modules/auth/repository/device_id_storage.dart';

class TrustDeviceMethods {
  final _authApi = AuthApi();

  Future trustDevice(
    String login,
    String password,
  ) async {
    final deviceId = await DeviceIdStorage.getDeviceId();
    final deviceName = await DeviceIdStorage.getDeviceName();
    return _authApi.trustDevice(
      deviceId,
      deviceName,
      login,
      password,
      AppStore.authState.authToken,
    );
  }
}
