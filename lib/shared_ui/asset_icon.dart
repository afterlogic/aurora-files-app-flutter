import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class AssetIcon extends StatelessWidget {
  final String res;
  final double? size;
  final double? addedSize;
  final Color? color;

  const AssetIcon(this.res, {super.key, this.size, this.addedSize, this.color});

  @override
  Widget build(BuildContext context) {
    final theme = IconTheme.of(context);
    return SvgPicture.asset(
      res,
      width: (size ?? theme.size ?? 0) + (addedSize ?? 0),
      height: (size ?? theme.size ?? 0) + (addedSize ?? 0),
      color: color ?? theme.color,
    );
  }
}
