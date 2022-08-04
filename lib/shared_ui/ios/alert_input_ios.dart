import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AlertInputIos extends StatelessWidget {
  final TextEditingController controller;
  final String placeholder;
  final IconData? icon;
  final bool autofocus;
  final bool enable;

  const AlertInputIos({
    Key? key,
    required this.controller,
    required this.placeholder,
    this.icon,
    this.autofocus = false,
    this.enable = true,
  }) : super(key: key);

  Widget build(BuildContext context) {
    return CupertinoTextField(
      enabled: enable,
      autofocus: enable && autofocus,
      controller: controller,
      prefix: icon == null
          ? null
          : Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Icon(icon, color: Colors.black26),
            ),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.black26),
      ),
      placeholder: placeholder,
    );
  }
}
