import 'package:flutter/material.dart';

class MainGradient extends StatelessWidget {
  final Widget child;

  const MainGradient({Key key, this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          stops: [0, 1],
          colors: [
            Color(0xFF420324),
            Color(0xFF252352),
          ],
        ),
      ),
      child: child,
    );
  }
}
