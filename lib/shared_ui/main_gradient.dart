import 'package:aurorafiles/build_property.dart';
import 'package:theme/app_color.dart';
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
            _fromHex(BuildProperty.splashGradientTop),
            _fromHex(BuildProperty.splashGradientBottom),
          ],
        ),
      ),
      child: child,
    );
  }

  Color _fromHex(String hexString) {
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
    buffer.write(hexString.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }
}
