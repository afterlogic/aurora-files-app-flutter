import 'package:aurorafiles/example_widget/test_widget/category_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FlutterCategory extends StatelessWidget {
  const FlutterCategory({super.key});

  @override
  Widget build(BuildContext context) {
    return CategoryWidget(
      "Flutter widgets",
      [
        AppBar(
          titleSpacing: NavigationToolbar.kMiddleSpacing,
          title: const Text("Title"),
        ),
        const Card(
          child: SizedBox(
            width: 100,
            height: 100,
          ),
        ),
        const TextButton(
          onPressed: null,
          child: Text("Button"),
        ),
        TextButton(
          child: const Text("Button"),
          onPressed: () {},
        ),
        const Icon(Icons.ac_unit),
        IconButton(
          icon: const Icon(Icons.ac_unit),
          onPressed: () {},
        ),
        Switch(value: false, onChanged: (_) {}),
        Switch(value: true, onChanged: (_) {}),
        CupertinoSwitch(onChanged: (bool value) {}, value: false,),
        CupertinoSwitch(onChanged: (bool value) {}, value: true,),
        Checkbox(onChanged: (bool? value) {}, value: false,),
        Checkbox(onChanged: (bool? value) {}, value: true,),
      ],
    );
  }
}
