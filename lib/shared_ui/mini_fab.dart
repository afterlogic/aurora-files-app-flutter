import 'package:aurorafiles/build_property.dart';
import 'package:aurorafiles/shared_ui/asset_svg_icon.dart';
import 'package:flutter/material.dart';
import 'package:theme/app_color.dart';

class MiniFab extends StatelessWidget {
  final Icon icon;
  final Function? onPressed;
  final String? text;
  final String? iconAsset;

  const MiniFab({
    required this.icon,
    this.onPressed,
    this.text,
    this.iconAsset,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (BuildProperty.flatDesign) {
      return _buildMenuStyle(context);
    }

    return FloatingActionButton(
      backgroundColor: Theme.of(context).cardColor,
      foregroundColor: Theme.of(context).iconTheme.color?.withOpacity(0.5),
      mini: true,
      elevation: BuildProperty.flatDesign ? 0.0 : null,
      onPressed: onPressed == null
          ? null
          : () {
              Navigator.pop(context);
              onPressed!.call();
            },
      child: icon,
    );
  }

  Widget _buildMenuStyle(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor = isDark ? const Color(0xFF2D2D2D) : Colors.white;
    final textColor = isDark ? Colors.white : const Color(0xFF031743);
    final iconColor = isDark ? AppColorDark.icons : AppColorLight.icons;

    return GestureDetector(
      onTap: onPressed == null
          ? null
          : () {
              Navigator.pop(context);
              onPressed!.call();
            },
      child: Container(
        padding: const EdgeInsets.only(
          top: 12,
          left: 16,
          right: 24,
          bottom: 12,
        ),
        clipBehavior: Clip.antiAlias,
        decoration: ShapeDecoration(
          color: backgroundColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          shadows: const [
            BoxShadow(
              color: Color(0x19000000),
              blurRadius: 16,
              offset: Offset(0, 8),
              spreadRadius: 0,
            )
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            AssetSvgIcon(
              showSvg: iconAsset != null,
              svgPath: iconAsset ?? '',
              iconData: icon.icon ?? Icons.not_interested_outlined,
              width: 24.0,
              height: 24.0,
              color: iconColor,
            ),
            if (text != null) ...[
              const SizedBox(width: 8),
              Text(
                text!,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: textColor,
                  fontSize: 14,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w500,
                  height: 1.35,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
