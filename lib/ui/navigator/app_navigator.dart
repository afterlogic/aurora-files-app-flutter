import 'dart:io';

import 'package:aurorafiles/ui/scene/auth/login/login_widget.dart';
import 'package:aurorafiles/ui/scene/main/files_browser/files_browser_widget.dart';
import 'package:aurorafiles/ui/view/fade_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';

class AppNavigator {
  static String initialRoute(bool hasToken) =>
      "/" + (hasToken ? _login : _main);

  static Route onGenerateRoute(RouteSettings settings) {
    if (settings.name == _main) {
      return _routeWrap(FilesBrowserWidget());
    } else if (settings.name == route) {
      return _routeWrap(LoginWidget());
    } else {
      assert(settings.arguments is Widget);
      return _routeWrap(settings.arguments);
    }
  }

  static Route _routeWrap(Widget widget) {
    if (Platform.isIOS && false) {
      return CupertinoPageRoute(builder: (context) => widget);
    } else {
      return FadeRoute(page: widget);
    }
  }

  static const _login = "login";
  static const _main = "main";
  static const route = "custom";
}
