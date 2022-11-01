import 'package:aurorafiles/models/share_access_history_item.dart';

class ShareAccessHistory {
  final int count;
  final List<ShareAccessHistoryItem> items;

  ShareAccessHistory({
    required this.count,
    required this.items,
  });

  factory ShareAccessHistory.fromJson(Map<String, dynamic> json) {
    return ShareAccessHistory(
      count: json["Count"] as int? ?? 0,
      items: (json["Items"] as List<dynamic>?)
              ?.map((e) =>
                  ShareAccessHistoryItem.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }
}
