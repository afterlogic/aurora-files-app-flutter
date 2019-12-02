import 'dart:async';
import 'package:aurorafiles/ui/navigator/app_navigator.dart';
import 'package:aurorafiles/ui/navigator/app_route.dart';
import 'package:aurorafiles/di/di.dart';
import 'package:aurorafiles/ui/themimg/material_theme.dart';
import 'package:aurorafiles/ui/view/main_gradient.dart';
import 'package:aurorafiles/ui/view/provider_widget.dart';
import 'package:domain/api/cache/storage/user_storage_api.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'locale/s.dart';

class BuilderApp extends StatefulWidget {
  @override
  _BuilderAppState createState() => _BuilderAppState();
}

class _BuilderAppState extends State<BuilderApp> {
  _AppLoadCase _appLoadCase;

  @override
  void initState() {
    super.initState();
    initDI();
  }

  initDI() {
    _appLoadCase = _AppLoadCase.Load;
    if (!DI.isInit) {
      DI.init().then(
        (_) {
          _appLoadCase = _AppLoadCase.Complete;
          setState(() {});
        },
        onError: (e, s) {
          _appLoadCase = _AppLoadCase.Error;
          setState(() {});
          print(e);
          print(s);
        },
      );
    } else {
      _appLoadCase = _AppLoadCase.Complete;
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return _App(_appLoadCase);
  }
}

class _App extends StatelessWidget {
  final _AppLoadCase _appLoadCase;

  const _App(this._appLoadCase);

  @override
  Widget build(BuildContext context) {
    if (_appLoadCase == _AppLoadCase.Complete) {
      final UserStorageApi userStorageApi = DI.get();
      //todo test
      final hasToken=false;
//      final hasToken = userStorageApi.token.get() != null;
      final isDarkTheme = userStorageApi.isDarkTheme.get() == true;
      final _navigatorKey = GlobalKey<NavigatorState>();
      DI.instance.add(AppNavigator(_navigatorKey));

      return ProviderWidget(
        value: S(),
        child: MaterialApp(
          title: "PrivateMail Files",
          theme: isDarkTheme
              ? AppMaterialTheme.darkTheme
              : AppMaterialTheme.commonTheme,
          onGenerateRoute: AppRoute.onGenerateRoute,
          initialRoute: AppRoute.initialRoute(hasToken),
          navigatorKey: _navigatorKey,
        ),
      );
    } else if (_appLoadCase == _AppLoadCase.Error) {
      //todo jopa crashlytics
      return Material(
          child: Center(
              child: SelectableText(
                  "Could not start the app, please make a screenshot of the error and send it to support@afterlogic.com and we'll fix it!")));
    } else {
      return Material(child: MainGradient());
    }
  }
}

enum _AppLoadCase {
  Load,
  Error,
  Complete,
}
