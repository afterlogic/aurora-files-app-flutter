import 'package:flutter/material.dart';

class MyButton extends StatelessWidget {
  final bool isLoading;
  final Function onPressed;

  const MyButton({Key key, this.isLoading, @required this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
        color: Theme.of(context).primaryColor,
        child: AnimatedSwitcher(
            duration: Duration(milliseconds: 100),
            child: isLoading
                ? SizedBox(
                    height: 24.0,
                    width: 24.0,
                    child: CircularProgressIndicator(
                      strokeWidth: 3.0,
                        valueColor:
                            AlwaysStoppedAnimation<Color>(Colors.white)),
                  )
                : Text("LOGIN")),
        onPressed: isLoading ? null : onPressed);
  }
}
