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
    final size = MediaQuery.of(context).size;
    return PlatformOverride.isIOS
        ? CupertinoAlertDialog(
            title: Text(
              s.import_keys,
              style: theme.textTheme.title,
            ),
            content: Flex(
              direction: Axis.vertical,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(
                  height: 200,
                  child: CupertinoTextField(
                    maxLines: null,
                    autofocus: true,
                    controller: _textController,
                  ),
                ),
                SizedBox(
                  width: double.infinity,
                  child: AMButton(
                      child: Text(s.check_keys),
                      onPressed: () {
                        Navigator.pop(context, _textController.text);
                      }),
                ),
                SizedBox(
                  width: double.infinity,
                  child: AMButton(
                    child: Text(s.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
              ],
            ),
          )
        : AlertDialog(
            title: Text(
              s.import_keys,
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
                  SizedBox(
                    width: double.infinity,
                    child: AMButton(
                        child: Text(s.check_keys),
                        onPressed: () {
                          if (formKey.currentState.validate()) {
                            Navigator.pop(context, _textController.text);
                          }
                        }),
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: AMButton(
                      child: Text(s.close),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                ],
              ),
            ),
          );
  }
}
