import 'package:aurora_ui_kit/aurora_ui_kit.dart';
import 'package:aurorafiles/generated/s_of_context.dart';
import 'package:aurorafiles/override_platform.dart';
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
    final s = Str.of(context);
    final theme = Theme.of(context);

    return AMDialog(
      title: Text(
        s.import_key,
        style: theme.textTheme.title,
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              height: 150,
              child: Form(
                key: formKey,
                child: TextFormField(
                  validator: (v) => validateInput(v, [
                    ValidationTypes.empty,
                  ]),
                  controller: _textController,
                  expands: true,
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                ),
              ),
            ),
          ],
        ),
      ),
      actions: <Widget>[
        FlatButton(
          child: Text(s.close),
          onPressed: () => Navigator.pop(context),
        ),
        FlatButton(
            child: Text(s.check_keys),
            onPressed: () {
              if (formKey.currentState.validate()) {
                Navigator.pop(context, _textController.text);
              }
            }),
      ],
    );
  }
}
