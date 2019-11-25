import 'package:domain/model/network/auth/auth_request.dart';
import 'package:domain/model/network/auth/auth_response.dart';

abstract class AuthNetworkApi {
  Future<String> getHostname(String domain);

  Future<AuthResponse> login(AuthRequest request);
}
