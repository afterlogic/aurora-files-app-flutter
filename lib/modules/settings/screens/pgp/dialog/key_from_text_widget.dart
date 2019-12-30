import 'dart:io';

import 'package:aurorafiles/generated/i18n.dart';
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
    final s = S.of(context);
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;
    return Platform.isIOS
        ? CupertinoAlertDialog(
      title: Text(
        s.import_keys,
        style: theme.textTheme.title,
      ),
      content: SizedBox(
        height: size.height / 2,
        child: Flex(
          direction: Axis.vertical,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Expanded(
              child: CupertinoTextField(
                style: TextStyle(color: Colors.white),
                maxLines: null,
                autofocus: true,
                controller: _textController,
              ),
            ),
            AppButton(
                width: double.infinity,
                text: s.check_keys.toUpperCase(),
                onPressed: () {
                  Navigator.pop(context, _textController.text);
                }),
            AppButton(
              width: double.infinity,
              text: s.close.toUpperCase(),
              onPressed: () => Navigator.pop(context),
            ),
          ],
        ),
      ),
    )
        : AlertDialog(
      title: Text(
        s.import_keys,
        style: theme.textTheme.title,
      ),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: Form(
              key: formKey,
              child: TextFormField(
                validator: (v) =>
                    validateInput(v, [
                      ValidationTypes.empty,
                    ]),
                controller: _textController,
                expands: true,
                keyboardType: TextInputType.multiline,
                maxLines: null,
              ),
            ),
          ),
          AppButton(
              width: double.infinity,
              text: s.check_keys.toUpperCase(),
              onPressed: () {
                if (formKey.currentState.validate()) {
                  Navigator.pop(context, _textController.text);
                }
              }),
          AppButton(
            width: double.infinity,
            text: s.close.toUpperCase(),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }
}
