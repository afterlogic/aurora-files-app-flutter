class Account {
  final int accountID;

  Account(this.accountID);

  factory Account.fromJson(Map<String, dynamic> item) {
    return Account(item["AccountID"]);
  }
}
