import 'package:aurorafiles/modules/files/dialogs/file_options_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:aurorafiles/shared_ui/layout_config.dart';

class CustomBottomSheet extends ModalRoute<FileOptionsBottomSheetResult> {
  final Widget child;

  CustomBottomSheet({required this.child});

  @override
  Duration get transitionDuration => Duration(milliseconds: 200);

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
      child: _buildOverlayContent(context),
    );
  }

  Widget _buildOverlayContent(BuildContext context) {
    final isTablet = LayoutConfig.of(context).isTablet;
    Widget content = ClipRRect(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20.0)),
      child: Container(
        width: MediaQuery.of(context).size.width,
        color: Theme.of(context).cardColor,
        child: child,
      ),
    );
    if (isTablet) {
      content = Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: LayoutConfig.formWidth,
          ),
          child: content,
        ),
      );
    }
    return Stack(
      children: <Widget>[
        Positioned.fill(
          child: InkWell(
            highlightColor: Colors.transparent,
            splashColor: Colors.transparent,
            child: Container(),
            onTap: () => Navigator.pop(context),
          ),
        ),
        Positioned(
          bottom: 0.0,
          left: 0,
          right: 0,
          child: content,
        ),
      ],
    );
  }

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    // You can add your own animations for the overlay content
    return SlideTransition(
      position:
          Tween<Offset>(begin: Offset(0.0, 0.5), end: Offset.zero).animate(
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
