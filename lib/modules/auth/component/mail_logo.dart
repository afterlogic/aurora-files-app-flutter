import 'package:aurorafiles/build_property.dart';
import 'package:flutter/material.dart';

class MailLogo extends StatelessWidget {
  final bool isBackground;

  const MailLogo({super.key, this.isBackground = false});

  @override
  Widget build(BuildContext context) {
    final size = isBackground ? 350.0 : 52.0;

    if (BuildProperty.useMainLogo) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32.0),
        child: Image.asset(BuildProperty.mainLogo),
      );
    } else {
      return Opacity(
        opacity: isBackground ? 0.05 : 1.0,
        child: Container(
          height: size,
          width: size,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.secondary,
            borderRadius: BorderRadius.circular(500.0),
          ),
          child: Icon(Icons.folder_open,
              size: isBackground ? 240.0 : 32.0, color: Colors.white),
        ),
      );
    }
  }
}
