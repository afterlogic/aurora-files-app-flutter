import 'dart:io';

import 'package:aurorafiles/shared_ui/app_button.dart';
import 'package:aurorafiles/utils/input_validation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class KeyFromTextWidget extends StatefulWidget {

  KeyFromTextWidget();

  @override
  _KeyFromTextWidgetState createState() => _KeyFromTextWidgetState();
}

class _KeyFromTextWidgetState extends State<KeyFromTextWidget> {
  TextEditingController _textController;
  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    _textController = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Platform.isIOS
        ? CupertinoAlertDialog(
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "Import keys",
                    style: theme.textTheme.title,
                  ),
                  Expanded(
                    child: Form(
                      key: formKey,
                      child: CupertinoTextField(
                       maxLines: 3000,
                        minLines: 3000,
                        autofocus: true,
                        controller: _textController,
                      ),
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
              ),
            ),
          )
        : AlertDialog(
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  "Import keys",
                  style: theme.textTheme.title,
                ),
                Expanded(
                  child: Form(
                    key: formKey,
                    child: TextFormField(
                      validator: (v) => validateInput(v, [
                        ValidationTypes.empty,
                      ]),
                      controller: _textController,
                      keyboardType: TextInputType.multiline,
                      maxLines: null,
                    ),
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
            ),
          );
  }
}
