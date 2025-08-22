import 'package:flutter/material.dart';

class AuthFormThemes {
  static BoxDecoration light(BuildContext context) {
    return BoxDecoration(
      color: Colors.white.withOpacity(0.7),
      borderRadius: BorderRadius.circular(8),
      // border: Border.all(
      //   color: Colors.white.withOpacity(0.3),
      //   width: 1.0,
      // ),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.15),
          blurRadius: 30.0,
          offset: const Offset(0, 4),
        ),
      ],
    );
  }

  static BoxDecoration dark(BuildContext context) {
    return light(context);
    // return light(context).copyWith(
    //   fillColor: Colors.black.withOpacity(0.3),
    //   labelStyle: const TextStyle(color: Colors.white70),
    //   enabledBorder: const OutlineInputBorder(
    //     borderSide: BorderSide(color: Colors.grey)),

    // );
  }
}

class AuthInputStyleThemes {
  static TextStyle? light(BuildContext context) {
    return Theme.of(context).textTheme.bodyMedium?.copyWith(
          color: Colors.black,
        );
  }

  static TextStyle? dark(BuildContext context) {
    return light(context)?.copyWith(
      color: Colors.black,
    );
  }
}

class AuthInputDecorationThemes {
  static InputDecoration light(BuildContext context) {
    return InputDecoration(
      filled: true,
      fillColor: Colors.white.withOpacity(0.5),
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 14,
        vertical: 10,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10.0),
        borderSide: const BorderSide(color: Color(0xFFEBEBEB)),
      ),
      enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Color(0xFFEBEBEB)),
          borderRadius: BorderRadius.circular(10.0)),
      focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Color(0xFF1D67CD)),
          borderRadius: BorderRadius.circular(10.0)),

      floatingLabelBehavior: FloatingLabelBehavior.never,
      // hintText: labelText,
      // hintStyle: const TextStyle(
      //   color: Color(0xFFA6ACB8),
      // ),
      alignLabelWithHint: true,
      // labelText: '', //do not specify labelText, it comes from the parent widget
      labelStyle: const TextStyle(
        color: Color(0xFFA6ACB8),
      ),
      // prefixIcon: ', //do not specify prefixIcon, it comes from the parent widget
      // suffixIcon: '', //do not specify suffixIcon, it comes from the parent widget
    );
  }

  static InputDecoration dark(BuildContext context) {
    return light(context);
    // return light(context).copyWith(
    //   fillColor: Colors.black.withOpacity(0.3),
    //   labelStyle: const TextStyle(color: Colors.white70),
    //   enabledBorder: const OutlineInputBorder(
    //     borderSide: BorderSide(color: Colors.grey)),

    // );
  }
}
