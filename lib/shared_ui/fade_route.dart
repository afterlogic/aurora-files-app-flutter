import 'package:flutter/material.dart';

class FadeRoute extends PageRouteBuilder {
  final RouteSettings settings;
  final Widget page;
  final int duration;

  FadeRoute({required this.settings, required this.page, this.duration = 300})
      : super(
          settings: settings,
          transitionDuration: Duration(milliseconds: duration),
          pageBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
          ) =>
              page,
          transitionsBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
            Widget child,
          ) {
            return FadeTransition(
              opacity: animation,
              child: child,
            );
          },
        );
}
