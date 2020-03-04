class Account {
  final int accountID;
  final String friendlyName;

  Account(this.accountID, this.friendlyName);

  factory Account.fromJson(Map<String, dynamic> item) {
    return Account(item["AccountID"], item["FriendlyName"]);
  }
}
