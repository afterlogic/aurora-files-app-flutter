import 'package:flutter/material.dart';

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
    return TextFormField(
      style: style,
      validator: validator,
      keyboardType: keyboardType,
      controller: controller,
      obscureText: obscureText,
      autocorrect: keyboardType != null ? false : true,
      enabled: enabled,
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white.withOpacity(0.5),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 10,
        ),
        enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white.withOpacity(0.3)), borderRadius: BorderRadius.circular(10.0)),
        focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.white), borderRadius: BorderRadius.circular(10.0)),
        floatingLabelBehavior: FloatingLabelBehavior.never,
        alignLabelWithHint: true,
        labelText: labelText,
        prefixIcon: prefix,
        suffixIcon: suffix,
      ),
    );
  }
}
