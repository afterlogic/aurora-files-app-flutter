class ShareAccessHistoryItem {
  final DateTime? createdAt;
  final String? ipAddress;
  final String? action;
  final String? guestPublicId;

  ShareAccessHistoryItem({
    this.createdAt,
    this.ipAddress,
    this.action,
    this.guestPublicId,
  });

  factory ShareAccessHistoryItem.fromJson(Map<String, dynamic> json) {
    return ShareAccessHistoryItem(
      createdAt: DateTime.tryParse(json["CreatedAt"])?.toLocal(),
      ipAddress: json["IpAddress"],
      action: json["Action"],
      guestPublicId: json["GuestPublicId"],
    );
  }
}
