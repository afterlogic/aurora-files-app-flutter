import 'dart:io';

import 'package:aurorafiles/generated/i18n.dart';
import 'package:aurorafiles/modules/settings/screens/pgp/dialog/import_pgp_key_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SignCheckBox extends StatefulWidget {
  final bool checked;
  final String label;
  final bool enable;
  final Function(bool check) onCheck;

  const SignCheckBox({
    @required Key key,
    @required this.checked,
    @required this.enable,
    @required this.onCheck,
    @required this.label,
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
    final s = S.of(context);
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            CheckAnalog(widget.checked, widget.enable ? widget.onCheck : null),
            Text(
              s.sign_email,
              style: !widget.enable ? TextStyle(color: Colors.grey) : null,
            ),
          ],
        ),
        Divider(color: Colors.grey),
        if (widget.enable && Platform.isIOS)
          CupertinoTextField(
            controller: _passwordController,
            obscureText: _obscure,
            placeholder: s.password,
            suffix: GestureDetector(
              child: Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: Icon(_obscure ? Icons.visibility : Icons.visibility_off),
              ),
              onTap: () {
                _obscure = !_obscure;
                setState(() {});
              },
            ),
          ),
        if (widget.enable && !Platform.isIOS)
          TextFormField(
            controller: _passwordController,
            obscureText: _obscure,
            decoration: InputDecoration(
              labelText: s.password,
              suffix: GestureDetector(
                child: Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child:
                      Icon(_obscure ? Icons.visibility : Icons.visibility_off),
                ),
                onTap: () {
                  _obscure = !_obscure;
                  setState(() {});
                },
              ),
            ),
          ),
        SizedBox(height: 10),
        Text(
          widget.label ??
              (widget.checked
                  ? s.data_signed(s.email.toLowerCase())
                  : s.data_not_signed_but_enc(s.email.toLowerCase())),
          style: theme.textTheme.caption,
        ),
      ],
    );
  }
}
