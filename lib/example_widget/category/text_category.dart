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
              style: textTheme.headline6,
            ),
            Text(
              "Subtitle",
              style: textTheme.subtitle2,
            ),
            Text(
              "Headline",
              style: textTheme.headline5,
            ),
            Text(
              "Subhead",
              style: textTheme.subtitle1,
            ),
            Text(
              "Body1",
              style: textTheme.bodyText2,
            ),
            Text(
              "Body2",
              style: textTheme.bodyText1,
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
              style: textTheme.headline4,
            ),
            Text(
              "Display2",
              style: textTheme.headline3,
            ),
            Text(
              "Display3",
              style: textTheme.headline2,
            ),
            Text(
              "Display4",
              style: textTheme.headline1,
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
