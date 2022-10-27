import 'package:aurorafiles/models/share_principal.dart';

class Recipient extends SharePrincipal {
  final String email;
  final int? idUser;
  final String? fullName;
  final String? pgpPublicKey;

  Recipient({
    required this.email,
    this.idUser,
    this.fullName,
    this.pgpPublicKey,
  });

  static Recipient fromJson(Map<String, dynamic> map) {
    return Recipient(
      email: map["ViewEmail"],
      idUser: map["IdUser"],
      fullName: map["FullName"],
      pgpPublicKey: null,
    );
  }

  @override
  String getId() => email;

  @override
  String getLabel() => email;

  @override
  Map<String, dynamic> toMap() {
    return {
      "PublicId": email,
    };
  }
}
