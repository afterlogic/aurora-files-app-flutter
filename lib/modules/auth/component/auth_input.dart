import 'package:flutter/material.dart';
import 'package:theme/auth_input_theme.dart';

class AuthInput extends StatelessWidget {
  final TextStyle? style;
  final TextEditingController? controller;
  final bool obscureText;
  final String? labelText;
  final Widget? suffix;
  final TextInputType? keyboardType;
  final Widget? prefix;
  final bool? enabled;
  final String? Function(String?)? validator;

  const AuthInput({
    Key? key,
    this.style,
    this.controller,
    this.obscureText = false,
    this.labelText,
    this.prefix,
    this.suffix,
    this.keyboardType,
    this.validator,
    this.enabled,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return TextFormField(
      style: isDark 
        ? AuthInputStyleThemes.dark(context) 
        : AuthInputStyleThemes.light(context),
      validator: validator,
      keyboardType: keyboardType,
      controller: controller,
      obscureText: obscureText,
      autocorrect: keyboardType != null ? false : true,
      enabled: enabled,
      decoration: (isDark 
        ? AuthInputDecorationThemes.dark(context) 
        : AuthInputDecorationThemes.light(context)
      ).copyWith(
        labelText: labelText,
        prefixIcon: prefix,
        suffixIcon: suffix,
      ),
    );
  }
}
