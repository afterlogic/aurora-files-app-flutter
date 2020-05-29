class Recipient {
  final String email;
  final int idUser;
  final String fullName;

  final String pgpPublicKey;

  Recipient({this.email, this.idUser, this.fullName, this.pgpPublicKey});

  static Recipient fromJson(Map<String, dynamic> map) {
    return Recipient(
      email: map["ViewEmail"],
      idUser: map["IdUser"],
      fullName: map["FullName"],
      pgpPublicKey: null,
    );
  }
}
