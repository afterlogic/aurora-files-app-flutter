import 'package:aurorafiles/example_widget/test_widget/group_label.dart';
import 'package:flutter/material.dart';

class LabelWidget extends StatelessWidget {
  final Widget widget;
  final String name;
  final String description;

  const LabelWidget(this.widget, {this.name, this.description});

  @override
  Widget build(BuildContext context) {
    var name = this.name ?? widget.runtimeType.toString();
    var description = this.description;

    if (widget is GroupLabel) {
      name = (widget as GroupLabel).name;
      description = (widget as GroupLabel).description;
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Container(
          width: double.infinity,
          color: Colors.black12,
          padding: EdgeInsets.all(10),
          child: Text(
            "Widget: " + name + (description != null ? "\n$description" : ""),
            textAlign: TextAlign.center,
          ),
        ),
        widget,
      ],
    );
  }
}
