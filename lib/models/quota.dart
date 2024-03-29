import 'package:filesize/filesize.dart';

class Quota {
  final int? limit;
  final int? used;

  Quota(this.limit, this.used);

  static Quota getQuotaFromResponse(Map<String, dynamic> quota) {
    return Quota(quota["Limit"], quota["Used"]);
  }

  double get progress => 100 / (limit ?? 1) * (used ?? 1) / 100;

  String get limitFormatted => filesize(limit);

  String get usedFormatted => filesize(used);

  String get availableFormatted => filesize((limit ?? 0) - (used ?? 0));
}
