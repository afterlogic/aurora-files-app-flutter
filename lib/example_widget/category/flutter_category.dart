import 'package:aurorafiles/example_widget/test_widget/category_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FlutterCategory extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CategoryWidget(
      "Flutter widgets",
      [
        AppBar(
          titleSpacing: NavigationToolbar.kMiddleSpacing,
          title: Text("Title"),
        ),
        Card(
          child: SizedBox(
            width: 100,
            height: 100,
          ),
        ),
        TextButton(
          child: Text("Button"),
          onPressed: null,
        ),
        TextButton(
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
        CupertinoSwitch(onChanged: (bool value) {}, value: false,),
        CupertinoSwitch(onChanged: (bool value) {}, value: true,),
        Checkbox(onChanged: (bool value) {}, value: false,),
        Checkbox(onChanged: (bool value) {}, value: true,),
      ],
    );
  }
}
