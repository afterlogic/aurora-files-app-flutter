import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AppButton extends StatelessWidget {
  final bool isLoading;
  final Function onPressed;
  final Widget child;
  final String text;
  final Color buttonColor;
  final Color textColor;
  final double width;

  const AppButton(
      {Key key,
      this.isLoading,
      @required this.onPressed,
      this.child,
      this.buttonColor,
      this.text,
      this.textColor,
      this.width})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (Platform.isIOS) {
      return Container(
        padding: EdgeInsets.symmetric(vertical: buttonColor != null ? 10 : 0),
        width: width,
        height: 55.0,
        child: CupertinoButton(
            color: buttonColor,
            child: AnimatedSwitcher(
              duration: Duration(milliseconds: 100),
              child: isLoading != null && isLoading
                  ? SizedBox(
                      height: 24.0,
                      width: 24.0,
                      child: CupertinoActivityIndicator())
                  : child is Widget
                      ? child
                      : Text(
                          text,
                          style: TextStyle(
                              color: textColor == null
                                  ? Theme.of(context).accentColor
                                  : textColor),
                        ),
            ),
            onPressed: isLoading != null && isLoading ? null : onPressed),
      );
    } else {
      return Container(
        width: width,
        child: RaisedButton(
            color: buttonColor,
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
                  : child is Widget ? child : Text(text.toUpperCase()),
            ),
            onPressed: isLoading == true ? null : onPressed),
      );
    }
  }
}
