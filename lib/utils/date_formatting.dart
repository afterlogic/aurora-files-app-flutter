import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

class DateFormatting {
  static String formatDateFromSeconds(
      {@required int timestamp, String format = "dd MMM yyyy"}) {
    return DateFormat(format)
        .format(DateTime.fromMillisecondsSinceEpoch((timestamp * 1000)));
  }

  static String shortDateTime(DateTime date) {
    if (date == null) return '';
    String format = "yy.MM.dd HH:mm:ss";
    return DateFormat(format).format(date);
  }
}
