import 'package:aurorafiles/build_property.dart';
import 'package:flutter/material.dart';

class InputUtils {
  /// Возвращает InputDecoration с кастомными стилями если useCustomInputStyles = true
  static InputDecoration getCustomInputDecoration({
    String? labelText,
    String? hintText,
    Widget? suffixIcon,
    EdgeInsets? contentPadding,
  }) {
    if (!BuildProperty.useCustomInputStyles) {
      return InputDecoration(
        labelText: labelText,
        hintText: hintText,
        suffixIcon: suffixIcon,
        focusedBorder: InputBorder.none,
      );
    }

    return InputDecoration(
      labelText: labelText,
      hintText: hintText,
      floatingLabelBehavior: FloatingLabelBehavior.auto,
      suffixIcon: suffixIcon,
      filled: true,
      fillColor: const Color(0x7FF4F4F4),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.0),
        borderSide: const BorderSide(color: Color(0xFFEAEAEA), width: 1.0),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.0),
        borderSide: const BorderSide(color: Color(0xFFEAEAEA), width: 1.0),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.0),
        borderSide: const BorderSide(color: Color(0xFFEAEAEA), width: 1.0),
      ),
      labelStyle: const TextStyle(color: Color(0xFF6E788D)),
      hintStyle: const TextStyle(color: Color(0xFF6E788D)),
      contentPadding: contentPadding ??
          const EdgeInsets.symmetric(vertical: 18.0, horizontal: 20.0),
    );
  }

  /// Обертка для TextFormField с кастомными стилями
  static Widget buildCustomTextFormField({
    required TextEditingController controller,
    String? labelText,
    String? hintText,
    TextInputType? keyboardType,
    Widget? suffixIcon,
    bool enabled = true,
    String? Function(String?)? validator,
    ValueChanged<String>? onChanged,
    VoidCallback? onEditingComplete,
    FocusNode? focusNode,
    bool obscureText = false,
    int? maxLines = 1,
    bool autofocus = false,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      enabled: enabled,
      validator: validator,
      onChanged: onChanged,
      onEditingComplete: onEditingComplete,
      focusNode: focusNode,
      obscureText: obscureText,
      maxLines: maxLines,
      autofocus: autofocus,
      decoration: getCustomInputDecoration(
        labelText: labelText,
        hintText: hintText,
        suffixIcon: suffixIcon,
      ),
    );
  }

  /// Обертка для TextField с кастомными стилями
  static Widget buildCustomTextField({
    required TextEditingController controller,
    String? labelText,
    String? hintText,
    TextInputType? keyboardType,
    Widget? suffixIcon,
    bool enabled = true,
    ValueChanged<String>? onChanged,
    VoidCallback? onEditingComplete,
    FocusNode? focusNode,
    bool obscureText = false,
    int? maxLines = 1,
    bool autofocus = false,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      enabled: enabled,
      onChanged: onChanged,
      onEditingComplete: onEditingComplete,
      focusNode: focusNode,
      obscureText: obscureText,
      maxLines: maxLines,
      autofocus: autofocus,
      decoration: getCustomInputDecoration(
        labelText: labelText,
        hintText: hintText,
        suffixIcon: suffixIcon,
      ),
    );
  }
}