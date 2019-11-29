import 'dart:async';
import 'package:aurorafiles/ui/navigator/app_navigator.dart';
import 'package:aurorafiles/di/di.dart';
import 'package:aurorafiles/ui/themimg/material_theme.dart';
import 'package:aurorafiles/ui/view/main_gradient.dart';
import 'package:domain/api/cache/storage/user_storage_api.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BuilderApp extends StatefulWidget {
  @override
  _BuilderAppState createState() => _BuilderAppState();
}

class _BuilderAppState extends State<BuilderApp> {
  Future _dependencyInitialization;
  _AppLoadCase _appLoadCase;

  @override
  void initState() {
    super.initState();
    initDI();
  }

  initDI() {
    _appLoadCase = _AppLoadCase.Load;
    if (!DI.isInit) {
      _dependencyInitialization = DI.init().then((_) {
        _appLoadCase = _AppLoadCase.Complete;
      }, onError: (e, s) {
        _appLoadCase = _AppLoadCase.Error;
        print(e);
        print(s);
      });
    } else {
      _appLoadCase = _AppLoadCase.Complete;
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _dependencyInitialization,
        builder: (_, AsyncSnapshot snapshot) {
          final appCase = snapshot.hasError
              ? _AppLoadCase.Error
              : snapshot.connectionState == ConnectionState.done
                  ? _AppLoadCase.Complete
                  : _AppLoadCase.Load;

          return App(appCase);
        });
  }
}

class App extends StatelessWidget {
  final _AppLoadCase _appLoadCase;

  const App(this._appLoadCase);

  @override
  Widget build(BuildContext context) {
    if (_appLoadCase == _AppLoadCase.Complete) {
      final UserStorageApi userStorageApi = DI.get();
      final hasToken = userStorageApi.token.get() != null;
      final isDarkTheme = userStorageApi.isDarkTheme.get() == true;

      return MaterialApp(
        title: "PrivateMail Files",
        theme: isDarkTheme
            ? AppMaterialTheme.darkTheme
            : AppMaterialTheme.commonTheme,
        onGenerateRoute: AppNavigator.onGenerateRoute,
        initialRoute: AppNavigator.initialRoute(hasToken),
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
