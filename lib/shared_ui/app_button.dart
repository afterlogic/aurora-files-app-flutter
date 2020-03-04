import 'package:aurorafiles/override_platform.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:theme/app_color.dart';

class AppButton extends StatelessWidget {
  final Function onPressed;
  final String text;
  final bool isLoading;
  final ButtonCase buttonCase;
  final double width;

  const AppButton({
    Key key,
    this.isLoading,
    this.onPressed,
    this.text,
    this.width,
    this.buttonCase = ButtonCase.Default,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isIOS = PlatformOverride.isIOS;
    final theme = Theme.of(context);

    Color selectFillColor() {
      switch (buttonCase) {
        case ButtonCase.Default:
          if (isIOS) {
            return null;
          } else {
            return theme.accentColor;
          }
          break;
        case ButtonCase.Filled:
          return theme.accentColor;
          break;
        case ButtonCase.Cancel:
          return theme.colorScheme.surface;
          break;
        case ButtonCase.Warning:
          if (isIOS) {
            return null;
          } else {
            return theme.errorColor;
          }
          break;
      }
      return null;
    }

    final fillColor = selectFillColor();



    if (PlatformOverride.isIOS) {
      return Container(
        margin: EdgeInsets.symmetric(vertical: fillColor != null ? 10 : 0),
        width: width,
        height: fillColor != null ? 45.0 : 55.0,
        child: CupertinoButton(
            color: fillColor,
            child: AnimatedSwitcher(
              duration: Duration(milliseconds: 100),
              child: isLoading == true
                  ? SizedBox(
                      height: 24.0,
                      width: 24.0,
                      child: CupertinoActivityIndicator())
                  : Text(text,
                      style: TextStyle(
                          color: onPressed != null
                              ? null
                              : theme.disabledColor)),
            ),
            onPressed: isLoading != null && isLoading ? null : onPressed),
      );
    } else {
      return Container(
        width: width,
        child: RaisedButton(
            color: fillColor,
            child: AnimatedSwitcher(
              duration: Duration(milliseconds: 100),
              child: isLoading != null && isLoading
                  ? SizedBox(
                      height: 24.0,
                      width: 24.0,
                      child: CircularProgressIndicator(
                          strokeWidth: 3.0,
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.white)),
                    )
                  : Text(
                      text.toUpperCase(),
                      style: TextStyle(
                          color: onPressed != null
                              ? null
                              : theme.disabledColor),
                    ),
            ),
            onPressed: isLoading == true ? null : onPressed),
      );
    }
  }
}

enum ButtonCase { Default, Filled, Cancel, Warning }
