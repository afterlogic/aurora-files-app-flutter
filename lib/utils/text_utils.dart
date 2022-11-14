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

  static TextSpan highlightFirstPartOfText({
    required String text,
    required String? part,
    required TextStyle? positiveStyle,
    required TextStyle? negativeStyle,
  }) {
    if (part == null || part == "") {
      return TextSpan(text: text, style: negativeStyle);
    }

    var refinedText = text.toLowerCase();
    var refinedPart = part.toLowerCase();
    if (!refinedText.contains(refinedPart)) {
      return TextSpan(text: text, style: negativeStyle);
    }

    final start = refinedText.indexOf(refinedPart);
    final end = start + refinedPart.length;
    final firstSpan = TextSpan(
      text: text.substring(0, start),
      style: negativeStyle,
    );
    final secondSpan = TextSpan(
      text: text.substring(start, end),
      style: positiveStyle,
    );
    final thirdSpan = TextSpan(
      text: text.substring(end),
      style: negativeStyle,
    );

    return TextSpan(
      children: [firstSpan, secondSpan, thirdSpan],
    );
  }

  static TextSpan highlightPartOfText({
    required String text,
    required String? part,
    required TextStyle? positiveStyle,
    required TextStyle? negativeStyle,
  }) {
    if (part == null || part == "") {
      return TextSpan(text: text, style: negativeStyle);
    }

    var refinedMatch = text.toLowerCase();
    var refinedSearch = part.toLowerCase() ?? '';
    if (refinedMatch.contains(refinedSearch)) {
      if (refinedMatch.substring(0, refinedSearch.length) == refinedSearch) {
        return TextSpan(
          style: positiveStyle,
          text: text.substring(0, refinedSearch.length),
          children: [
            highlightPartOfText(
              text: text.substring(refinedSearch.length),
              part: part,
              positiveStyle: positiveStyle,
              negativeStyle: negativeStyle,
            ),
          ],
        );
      } else if (refinedMatch.length == refinedSearch.length) {
        return TextSpan(text: text, style: positiveStyle);
      } else {
        return TextSpan(
          style: negativeStyle,
          text: text.substring(
            0,
            refinedMatch.indexOf(refinedSearch),
          ),
          children: [
            highlightPartOfText(
              text: text.substring(refinedMatch.indexOf(refinedSearch)),
              part: part,
              positiveStyle: positiveStyle,
              negativeStyle: negativeStyle,
            ),
          ],
        );
      }
    } else if (!refinedMatch.contains(refinedSearch)) {
      return TextSpan(text: text, style: negativeStyle);
    }

    return TextSpan(
      text: text.substring(0, refinedMatch.indexOf(refinedSearch)),
      style: negativeStyle,
      children: [
        highlightPartOfText(
          text: text.substring(refinedMatch.indexOf(refinedSearch)),
          part: part,
          positiveStyle: positiveStyle,
          negativeStyle: negativeStyle,
        )
      ],
    );
  }
}
