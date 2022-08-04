import 'package:flutter/material.dart';

class AppInput extends StatelessWidget {
  final TextStyle? style;
  final TextEditingController? controller;
  final bool obscureText;
  final String? labelText;
  final Widget? suffix;
  final TextInputType? keyboardType;
  final Widget? prefix;
  final bool? enabled;
  final String? Function(String?)? validator;
  final InputCase inputCase;

  const AppInput({
    Key? key,
    this.style,
    this.controller,
    this.obscureText = false,
    this.labelText,
    this.suffix,
    this.keyboardType,
    this.prefix,
    this.inputCase = InputCase.Default,
    this.validator,
    this.enabled,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return TextFormField(
      style: style,
      validator: validator,
      keyboardType: keyboardType,
      cursorColor: theme.colorScheme.secondary,
      controller: controller,
      obscureText: obscureText,
      autocorrect: keyboardType != null ? false : true,
      enabled: enabled,
      decoration: InputDecoration(
        alignLabelWithHint: true,
        labelText: labelText,
        prefixIcon: prefix,
        suffixIcon: suffix,
      ),
    );
  }
}

enum InputCase { Default, Underline }
