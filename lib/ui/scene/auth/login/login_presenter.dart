import 'package:aurorafiles/ui/navigator/app_navigator.dart';
import 'package:dio/dio.dart';
import 'package:domain/api/cache/storage/user_storage_api.dart';
import 'package:domain/api/network/auth_network_api.dart';
import 'package:domain/api/network/error/network_error.dart';
import 'package:domain/error/base_error.dart';
import 'package:domain/model/network/auth/auth_request.dart';
import 'package:domain/error/error_code.dart';
import 'login_view.dart';
import 'package:mpv/mpv.dart';

class LoginPresenter extends Presenter<LoginView> {
  final AuthNetworkApi _authNetwork;
  final UserStorageApi _userStorage;
  final AppNavigator _appNavigator;
  final Dio _dio;

  LoginPresenter(
    LoginView view,
    this._authNetwork,
    this._dio,
    this._userStorage,
    this._appNavigator,
  ) : super(view);

  void login(
    String host,
    String email,
    String pass,
  ) async {
    view.progress.add(true);
    cancelable("login", _login(host, email, pass)).then((success) {
      view.progress.add(false);
      if (success) {
        _appNavigator.toFileBrowser();
      } else {
        view.showHost();
      }
    }, onError: (e, s) {
      if (e is BaseError) {
        _onError(e);
      } else if (e is DioError) {
        _onError(e.error);
      } else {
        _onError(null);
      }
    });
  }

  _onError(BaseError e) {
    view.progress.add(false);
    if (e == null) {
      view.showError(null);
    } else if (e is NetworkError && e.code == ErrorCode.accessDenied) {
      _appNavigator.toUpgrade();
    } else {
      view.showError(e.errorCase, e.description);
    }
  }

  Future<bool> _login(
    String host,
    String email,
    String pass,
  ) async {
    var _host = "";
    _dio.options.baseUrl = "";
    if (host.isEmpty) {
      _host = await _authNetwork.getHostname(email);
      if (_host.isEmpty) {
        return false;
      }
    } else {
      _host = host.startsWith(RegExp("(http://|https://)"))
          ? host
          : "https://$host";
    }
    _dio.options.baseUrl = _host;
    final response = await _authNetwork.login(AuthRequest(email, pass));
    await _userStorage.host.set(_host);
    await _userStorage.userEmail.set(email);
    await _userStorage.token.set(response.authToken);
    await _userStorage.userId.set(response.userId);
    return true;
  }
}
