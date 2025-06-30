import 'package:aurorafiles/build_property.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:theme/app_color.dart';

class CustomSpeedDial extends ModalRoute<void> {
  final String tag;
  final List<Widget> children;

  CustomSpeedDial({required this.tag, required this.children});

  @override
  Duration get transitionDuration =>
      Duration(milliseconds: 75 + 38 * children.length);

  @override
  bool get opaque => false;

  @override
  bool get barrierDismissible => false;

  @override
  Color get barrierColor => BuildProperty.flatDesign
      ? Colors.transparent
      : Colors.black.withOpacity(0.4);

  @override
  String? get barrierLabel => null;

  @override
  bool get maintainState => true;

  @override
  Widget buildPage(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
  ) {
    // This makes sure that text and other content follows the material style
    return Material(
      type: MaterialType.transparency,
      // make sure that the overlay content is not cut off
      child: SafeArea(
        child: _buildOverlayContent(context, animation),
      ),
    );
  }

  Widget _buildOverlayContent(
      BuildContext context, Animation<double> animation) {
    final double part = 1.0 / children.length;
    final fabAnimation = Tween<double>(
      begin: 0.0,
      end: 0.62,
    ).animate(
      CurvedAnimation(
        parent: animation,
        curve: Curves.easeInOutSine,
      ),
    );

    return InkWell(
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      onTap: Navigator.of(context).pop,
      child: Stack(children: [
        Positioned(
          bottom: 16.0,
          right: 16.0,
          child: Column(
            crossAxisAlignment: BuildProperty.flatDesign
                ? CrossAxisAlignment.end
                : CrossAxisAlignment.center,
            children: <Widget>[
              ...children.map((Widget child) {
                int index = children.indexOf(child);
                final miniFabsAnimation = Tween<double>(
                  begin: 0.0,
                  end: 1.0,
                ).animate(
                  CurvedAnimation(
                    parent: animation,
                    curve: Interval(
                      1.0 - (part * index + part - 0.1),
                      1.0 - (part * index - index / 10),
                      curve: Curves.easeOutSine,
                    ),
                  ),
                );

                return ScaleTransition(
                  scale: miniFabsAnimation,
                  child: FadeTransition(
                    opacity: miniFabsAnimation,
                    child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: child,
                    ),
                  ),
                );
              }),
              const SizedBox(height: 14.0),
              FloatingActionButton(
                heroTag: tag,
                elevation: 0.0,
                onPressed: Navigator.of(context).pop,
                child: RotationTransition(
                  turns: fabAnimation,
                  child: const Icon(Icons.add),
                ),
              ),
            ],
          ),
        ),
      ]),
    );
  }

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    // You can add your own animations for the overlay content
    return SlideTransition(
      position: Tween<Offset>(begin: Offset.zero, end: Offset.zero).animate(
        CurvedAnimation(
          parent: animation,
          curve: Curves.easeOutCubic,
          reverseCurve: Curves.easeOut,
        ),
      ),
      child: child,
    );
  }
}

class MiniFab extends StatelessWidget {
  final Icon icon;
  final Function? onPressed;
  final String? text;
  final String? iconAsset;

  const MiniFab({
    Key? key,
    required this.icon,
    this.onPressed,
    this.text,
    this.iconAsset,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (BuildProperty.flatDesign) {
      return _buildMenuStyle(context);
    }

    // Стандартный дизайн для других тем
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
            // Для unlyme: приоритет iconAsset, если нет то icon
            if (iconAsset != null)
              SvgPicture.asset(
                iconAsset!,
                width: 24,
                height: 24,
                color: iconColor,
              )
            else
              SizedBox(
                width: 24,
                height: 24,
                child: Icon(
                  icon.icon,
                  size: 24,
                  color: iconColor,
                ),
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
