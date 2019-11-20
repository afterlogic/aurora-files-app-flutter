import 'dart:io';

import 'package:aurorafiles/shared_ui/app_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class KeyFromTextWidget extends StatefulWidget {
  final String _text;

  KeyFromTextWidget(this._text);

  @override
  _KeyFromTextWidgetState createState() => _KeyFromTextWidgetState();
}

class _KeyFromTextWidgetState extends State<KeyFromTextWidget> {
  TextEditingController _textController;
  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    _textController = TextEditingController(text: widget._text ?? "");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final content = Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          "Import keys",
          style: theme.textTheme.title,
        ),
        Form(
          key: formKey,
          child: TextFormField(
            validator: (v) {
              if (v.isEmpty) {
                return "Empty field";
              }
              return null;
            },
            controller: _textController,
            keyboardType: TextInputType.multiline,
            maxLines: null,
          ),
        ),
        AppButton(
            width: double.infinity,
            text: "Check keys".toUpperCase(),
            onPressed: () {
              if (formKey.currentState.validate()) {
                Navigator.pop(context, _textController.text);
              }
            }),
        AppButton(
          width: double.infinity,
          text: "Close".toUpperCase(),
          onPressed: () => Navigator.pop(context),
        ),
      ],
    );

    return Platform.isIOS
        ? CupertinoAlertDialog(
            content: content,
          )
        : AlertDialog(
            content: SingleChildScrollView(child: content),
          );
  }
}
