import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class AssetIcon extends StatelessWidget {
  final String res;
  final double size;
  final double addedSize;

  const AssetIcon(this.res, {this.size, this.addedSize});

  @override
  Widget build(BuildContext context) {
    final theme = IconTheme.of(context);
    return SvgPicture.asset(
      res,
      width: (size ?? theme.size) + addedSize ?? 0,
      height: (size ?? theme.size) + addedSize ?? 0,
      color: theme.color,
    );
  }
}
