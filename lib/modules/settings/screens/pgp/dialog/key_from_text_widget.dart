import 'dart:io';

import 'package:aurorafiles/shared_ui/app_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class KeyFromTextWidget extends StatefulWidget {
  @override
  _KeyFromTextWidgetState createState() => _KeyFromTextWidgetState();
}

class _KeyFromTextWidgetState extends State<KeyFromTextWidget> {
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
        TextField(
          keyboardType: TextInputType.multiline,
          maxLines: null,
        ),
        AppButton(
          width: double.infinity,
          text: "Check keys".toUpperCase(),
          onPressed: () {},
        ),
        AppButton(
          width: double.infinity,
          text: "Close".toUpperCase(),
          onPressed: () {},
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
