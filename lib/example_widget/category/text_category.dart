import 'package:aurorafiles/example_widget/test_widget/category_widget.dart';
import 'package:aurorafiles/example_widget/test_widget/group_label.dart';
import 'package:flutter/material.dart';

class TextCategory extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    return CategoryWidget(
      "Text widgets",
      [
        GroupLabel(
          name: "Text Style",
          children: <Widget>[
            Text(
              "Title",
              style: textTheme.title,
            ),
            Text(
              "Subtitle",
              style: textTheme.subtitle,
            ),
            Text(
              "Headline",
              style: textTheme.headline,
            ),
            Text(
              "Subhead",
              style: textTheme.subhead,
            ),
            Text(
              "Body1",
              style: textTheme.body1,
            ),
            Text(
              "Body2",
              style: textTheme.body2,
            ),
            Text(
              "Button",
              style: textTheme.button,
            ),
            Text(
              "Caption",
              style: textTheme.caption,
            ),
            Text(
              "Display1",
              style: textTheme.display1,
            ),
            Text(
              "Display2",
              style: textTheme.display2,
            ),
            Text(
              "Display3",
              style: textTheme.display3,
            ),
            Text(
              "Display4",
              style: textTheme.display4,
            ),
            Text(
              "Overline",
              style: textTheme.overline,
            ),
          ],
        ),
      ],
    );
  }
}
