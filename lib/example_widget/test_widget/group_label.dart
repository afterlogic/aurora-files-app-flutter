import 'package:flutter/material.dart';

class GroupLabel extends StatelessWidget {
  final String name;
  final String description;
  final List<Widget> children;
  final EdgeInsets padding;
  final Color background;

  const GroupLabel({
    this.name,
    this.description,
    this.children,
    this.padding = const EdgeInsets.all(20),
    this.background,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: background,
      padding: padding,
      child: Column(
        children: children,
      ),
    );
  }
}
