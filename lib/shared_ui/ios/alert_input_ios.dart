import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AlertInputIos extends StatefulWidget {
  final bool autofocus;
  final IconData icon;
  final String placeholder;
  final TextEditingController controller;

  const AlertInputIos({
    Key key,
    @required this.controller,
    this.icon,
    @required this.placeholder,
    this.autofocus,
  }) : super(key: key);

  @override
  _AlertInputIosState createState() => _AlertInputIosState();
}

class _AlertInputIosState extends State<AlertInputIos> {
  @override
  Widget build(BuildContext context) {
    return CupertinoTextField(
      style: TextStyle(color: Colors.white),
      autofocus: widget.autofocus == null || widget.autofocus == false ? false : true,
      controller: widget.controller,
      prefix: widget.icon == null ? null : Padding(
        padding: const EdgeInsets.only(left: 8.0),
        child: Icon(widget.icon, color: Colors.black26),
      ),
      decoration: BoxDecoration(
          color: Colors.white, border: Border.all(color: Colors.black26)),
      placeholder: widget.placeholder,
    );
  }
}
