import 'package:aurorafiles/override_platform.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AppInput extends StatelessWidget {
  final bool withBorder;
  final TextStyle style;
  final TextEditingController controller;
  final bool obscureText;
  final String labelText;
  final Widget suffix;
  final TextInputType keyboardType;
  final Widget prefix;

  final String Function(String) validator;
  final InputCase inputCase;

  const AppInput({
    Key key,
    this.withBorder,
    this.style,
    this.controller,
    this.obscureText = false,
    this.labelText,
    this.suffix,
    this.keyboardType,
    this.prefix,
    this.inputCase = InputCase.Default,
    this.validator,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    if (PlatformOverride.isIOS) {
      return CupertinoTextField(
        style: theme.textTheme.subhead,
        cursorColor: theme.accentColor,
        placeholder: labelText,
        placeholderStyle: theme.textTheme.subhead.copyWith(color: theme.textTheme.subhead.color.withAlpha(100)),
        obscureText: obscureText,
        controller: controller,
        autocorrect: keyboardType != null ? false : true,
        prefix: prefix,
        decoration: inputCase == InputCase.Underline
            ? BoxDecoration(
                border: Border(bottom: BorderSide(color: Colors.white24)),
              )
            : BoxDecoration(),
        suffix: suffix,
        keyboardType: keyboardType,
      );
    } else {
      return TextFormField(
        style: style,
        validator: validator,
        keyboardType: keyboardType,
        cursorColor: theme.accentColor,
        controller: controller,
        obscureText: obscureText,
        autocorrect: keyboardType != null ? false : true,
        decoration: InputDecoration(
          alignLabelWithHint: true,
          labelText: labelText,
          prefixIcon: prefix,
          suffixIcon: suffix,
        ),
      );
    }
  }
}

enum InputCase { Default, Underline }
