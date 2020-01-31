import 'package:aurorafiles/example_widget/test_widget/category_widget.dart';
import 'package:aurorafiles/example_widget/test_widget/group_label.dart';
import 'package:flutter/material.dart';

class FlutterCategory extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    return CategoryWidget(
      "Flutter widgets",
      [
        AppBar(
          title: Text("Title"),
        ),
        Card(
          child: SizedBox(
            width: 100,
            height: 100,
          ),
        ),
        FlatButton(
          child: Text("Button"),
          onPressed: null,
        ),
        FlatButton(
          child: Text("Button"),
          onPressed: () {},
        ),
        Icon(Icons.ac_unit),
        IconButton(
          icon: Icon(Icons.ac_unit),
          onPressed: () {},
        ),
        Switch(value: false, onChanged: (_) {}),
        Switch(value: true, onChanged: (_) {}),
      ],
    );
  }
}
