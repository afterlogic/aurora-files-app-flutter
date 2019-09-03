import 'package:flutter/material.dart';

class AppButton extends StatelessWidget {
  final bool isLoading;
  final Function onPressed;
  final Widget child;

  const AppButton(
      {Key key, this.isLoading, @required this.onPressed, @required this.child})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
//        color: Theme.of(context).primaryColor,
        child: AnimatedSwitcher(
          duration: Duration(milliseconds: 100),
          child: isLoading != null && isLoading
              ? SizedBox(
                  height: 24.0,
                  width: 24.0,
                  child: CircularProgressIndicator(
                      strokeWidth: 3.0,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white)),
                )
              : child,
        ),
        onPressed: isLoading != null && isLoading ? null : onPressed);
  }
}
