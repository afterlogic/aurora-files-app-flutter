import 'package:aurorafiles/build_property.dart';
import 'package:flutter/material.dart';

class LoginGradient extends StatelessWidget {
  final Widget? child;

  const LoginGradient({Key? key, this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          stops: const [0, 1],
          colors: [
            _fromHex(
              theme.brightness == Brightness.light
                  ? BuildProperty.splashGradientTop
                  : BuildProperty.splashGradientTopDark,
            ),
            _fromHex(
              theme.brightness == Brightness.light
                  ? BuildProperty.splashGradientBottom
                  : BuildProperty.splashGradientBottomDark,
            ),
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
