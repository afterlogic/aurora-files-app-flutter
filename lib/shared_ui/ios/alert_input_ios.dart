import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AlertInputIos extends StatelessWidget {
  final bool autofocus;
  final IconData icon;
  final String placeholder;
  final TextEditingController controller;
  final bool enable;

  const AlertInputIos({
    Key key,
    @required this.controller,
    this.icon,
    @required this.placeholder,
    this.autofocus,
    this.enable=true,
  }) : super(key: key);

  Widget build(BuildContext context) {
    return CupertinoTextField(
      enabled: enable,
      autofocus: enable&&autofocus == true ,
      controller: controller,
      prefix: icon == null
          ? null
          : Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Icon(icon, color: Colors.black26),
            ),
      decoration: BoxDecoration(color: Colors.white, border: Border.all(color: Colors.black26)),
      placeholder: placeholder,
    );
  }
}
