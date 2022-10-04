import 'package:aurora_ui_kit/aurora_ui_kit.dart';
import 'package:aurorafiles/l10n/l10n.dart';
import 'package:aurorafiles/utils/input_validation.dart';
import 'package:flutter/material.dart';

class KeyFromTextWidget extends StatefulWidget {
  KeyFromTextWidget();

  @override
  _KeyFromTextWidgetState createState() => _KeyFromTextWidgetState();
}

class _KeyFromTextWidgetState extends State<KeyFromTextWidget> {
  final _textController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final s = context.l10n;
    final theme = Theme.of(context);

    return AMDialog(
      title: Text(
        s.import_key,
        style: theme.textTheme.headline6,
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
                  validator: (v) =>
                      validateInput(v ?? '', [ValidationTypes.empty]),
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
        TextButton(
          child: Text(s.close),
          onPressed: () => Navigator.pop(context),
        ),
        TextButton(
            child: Text(s.check_keys),
            onPressed: () {
              if (formKey.currentState?.validate() == true) {
                Navigator.pop(context, _textController.text);
              }
            }),
      ],
    );
  }
}
