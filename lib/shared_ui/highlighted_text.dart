import 'package:aurorafiles/utils/text_utils.dart';
import 'package:flutter/material.dart';

class HighlightedText extends StatelessWidget {
  final String text;
  final String? highlightedPart;
  final TextStyle? textStyle;
  final TextStyle? highlightedTextStyle;

  const HighlightedText({
    Key? key,
    required this.text,
    this.highlightedPart,
    this.textStyle,
    this.highlightedTextStyle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (highlightedPart == null || highlightedPart?.isEmpty == true) {
      return Text(text);
    }
    final negativeStyle = textStyle ?? DefaultTextStyle.of(context).style;
    final positiveStyle = highlightedTextStyle ??
        negativeStyle.copyWith(
          backgroundColor: const Color.fromRGBO(49, 206, 216, 0.25),
        );
    return RichText(
      text: TextUtils.highlightFirstPartOfText(
        text: text,
        part: highlightedPart,
        positiveStyle: positiveStyle,
        negativeStyle: negativeStyle,
      ),
    );
  }
}
