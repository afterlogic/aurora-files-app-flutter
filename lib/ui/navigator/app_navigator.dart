import 'package:aurorafiles/ui/navigator/app_route.dart';
import 'package:aurorafiles/ui/scene/auth/update/upgrate_widget.dart';
import 'package:flutter/cupertino.dart';

class AppNavigator {
  final GlobalKey<NavigatorState> _navigatorKey;

  NavigatorState get _navigator => _navigatorKey.currentState;

  AppNavigator(this._navigatorKey);

  toLogin() {}

  Future toFileBrowser() {
//    return _navigator.push(_wrap(Files()));
  }

  Future toUpgrade() {
    return _navigator.push(_wrap(UpgradeWidget()));
  }

  Route _wrap(Widget widget) {
    return AppRoute.routeWrap(widget);
  }
}
