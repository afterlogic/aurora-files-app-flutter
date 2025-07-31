import 'package:aurorafiles/build_property.dart';
import 'package:flutter/material.dart';

class LoginGradient extends StatelessWidget {
  final Widget? child;

  const LoginGradient({Key? key, this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDark = !BuildProperty.alwaysLightTheme &&
        Theme.of(context).brightness == Brightness.dark;

    return Container(
      width: double.infinity,
      decoration: BuildProperty.useBackgroundImage
          ? const BoxDecoration(
              image: DecorationImage(
              image:
                  AssetImage(BuildProperty.imageDir + '/login_background.jpg'),
              fit: BoxFit.cover,
            ))
          : BoxDecoration(
              gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              stops: const [0, 1],
              colors: [
                _fromHex(isDark
                    ? BuildProperty.splashGradientTopDark
                    : BuildProperty.splashGradientTop),
                _fromHex(isDark
                    ? BuildProperty.splashGradientBottomDark
                    : BuildProperty.splashGradientBottom),
              ],
            )),
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
