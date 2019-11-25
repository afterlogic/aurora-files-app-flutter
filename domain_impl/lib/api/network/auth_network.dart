import 'package:dio/dio.dart';
import 'package:domain/model/network/auth/auth_request.dart';
import 'package:domain/model/network/auth/auth_response.dart';
import 'package:domain/api/network/auth_network_api.dart';
import 'package:domain_impl/api/network/route/module_core.dart';

class AuthNetwork implements AuthNetworkApi {
  final Dio _dio;

  AuthNetwork(this._dio);

  Future<String> getHostname(String domain) async {
    final url = "$_AUTO_DISCOVER_URL?domain=$domain";
    final result = await _dio.get(url);
    return result.data["url"];
  }

  Future<AuthResponse> login(AuthRequest request) async {
    final route = ModuleCore(CoreMethod.Login);
    final result = await _dio.post("", data: route.toJson());
    return AuthResponse.fromJson(result.data);
  }

  static const _AUTO_DISCOVER_URL = "https://torguard.tv/pm/autodiscover.php";
}
