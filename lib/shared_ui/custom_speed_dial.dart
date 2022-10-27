import 'package:flutter/material.dart';

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
  Color get barrierColor => Colors.black.withOpacity(0.4);

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

  const MiniFab({
    Key? key,
    required this.icon,
    this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      backgroundColor: Theme.of(context).cardColor,
      foregroundColor: Theme.of(context).iconTheme.color?.withOpacity(0.5),
      mini: true,
      onPressed: onPressed == null
          ? null
          : () {
              Navigator.pop(context);
              onPressed!.call();
            },
      child: icon,
    );
  }
}
