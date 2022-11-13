import 'package:flutter/rendering.dart';

class TextUtils {
  static bool hasTextOverflow(
    String text,
    TextStyle style,
    BoxConstraints size, [
    int maxLines = 1,
    TextDirection textDirection = TextDirection.ltr,
  ]) {
    final textPainter = TextPainter(
      text: TextSpan(text: text, style: style),
      maxLines: maxLines,
      textDirection: textDirection,
    );
    textPainter.layout(minWidth: size.minWidth, maxWidth: size.maxWidth);

    return textPainter.didExceedMaxLines;
  }
}
