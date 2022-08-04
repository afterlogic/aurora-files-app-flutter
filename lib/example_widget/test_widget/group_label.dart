import 'package:flutter/material.dart';

class GroupLabel extends StatelessWidget {
  final String name;
  final List<Widget> children;
  final String? description;
  final EdgeInsets padding;
  final Color? background;

  const GroupLabel({
    required this.name,
    required this.children,
    this.description,
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
