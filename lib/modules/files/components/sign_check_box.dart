import 'dart:io';

import 'package:aurorafiles/generated/s_of_context.dart';
import 'package:aurorafiles/override_platform.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SignCheckBox extends StatefulWidget {
  final bool checked;
  final bool enable;
  final Function(bool check) onCheck;

  const SignCheckBox({
    @required Key key,
    @required this.checked,
    @required this.enable,
    @required this.onCheck,
  }) : super(key: key);

  @override
  SignCheckBoxState createState() => SignCheckBoxState();
}

class SignCheckBoxState extends State<SignCheckBox> {
  final _passwordController = TextEditingController();
  bool _obscure = true;

  String get password => _passwordController.text;

  @override
  Widget build(BuildContext context) {
    final s = Str.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        ListTile(
          contentPadding: EdgeInsets.zero,
          onTap: widget.enable ? () => widget.onCheck(!widget.checked) : null,
          title: Text(
            s.sign_email,
            style: !widget.enable ? TextStyle(color: Colors.grey) : null,
          ),
          trailing: Switch.adaptive(
            value: widget.checked,
            activeColor: Theme.of(context).accentColor,
            onChanged: widget.enable ? widget.onCheck : null,
          ),
        ),
      ],
    );
  }
}
