import 'package:json_annotation/json_annotation.dart';

part 'auth_request.g.dart';

@JsonSerializable()
class AuthRequest {
  @JsonKey(name: "Login")
  final String login;
  @JsonKey(name: "Password")
  final String password;
  @JsonKey(name: "Pattern")
  final String pattern = "";

  AuthRequest(this.login, this.password);

  factory AuthRequest.fromJson(Map<String, dynamic> json) =>
      _$AuthRequestFromJson(json);

  Map<String, dynamic> toJson() => _$AuthRequestToJson(this);
}
