class Recipient {
  final String email;
  final int idUser;
  final String fullName;

  Recipient({this.email, this.idUser, this.fullName});

  static Recipient fromJson(Map<String, dynamic> map) {
    return Recipient(
      email: map["ViewEmail"],
      idUser: map["IdUser"],
      fullName: map["FullName"],
    );
  }
}
