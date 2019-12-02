import 'dart:io';

import 'package:aurorafiles/ui/scene/auth/login/login_widget.dart';
import 'package:aurorafiles/ui/scene/main/files_browser/files_browser_widget.dart';
import 'package:aurorafiles/ui/view/fade_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';

class AppRoute {
  static String initialRoute(bool hasToken) => (hasToken ? _main : _login);

  static Route onGenerateRoute(RouteSettings settings) {
    if (settings.name == _main) {
      return routeWrap(FilesBrowserWidget());
    } else if (settings.name == _login) {
      return routeWrap(LoginWidget(), true);
    } else if (settings.name == "/") {
      return routeWrap(SizedBox.shrink(), true);
    } else {
      assert(settings.arguments is Widget);
      return routeWrap(settings.arguments);
    }
  }

  static Route routeWrap(Widget widget, [bool isInitial = false]) {
    if (Platform.isIOS && false /* todo */) {
      return CupertinoPageRoute(
        settings: RouteSettings(isInitialRoute: isInitial),
        builder: (context) => widget,
      );
    } else {
      return FadeRoute(
        settings: RouteSettings(isInitialRoute: isInitial),
        page: widget,
      );
    }
  }

  static const _login = "/login";
  static const _main = "/main";
  static const route = "custom";
}
