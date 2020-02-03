import 'dart:io';

import 'package:aurorafiles/example_widget/category/app_category.dart';
import 'package:aurorafiles/example_widget/category/text_category.dart';
import 'package:aurorafiles/example_widget/test_widget/category_widget.dart';
import 'package:aurorafiles/generated/localization_string_widget.dart';
import 'package:aurorafiles/override_platform.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:theme/app_theme.dart';
import 'category/flutter_category.dart';

main() {
  PlatformOverride.setPlatform(Platform.isIOS);
  runApp(ExampleWidgetScreen());
}

openExample(BuildContext context) {
  Navigator.of(context)
      .push(MaterialPageRoute(builder: (_) => ExampleWidgetScreen()));
}

class ExampleWidgetScreen extends StatefulWidget {
  @override
  _ExampleWidgetScreenState createState() => _ExampleWidgetScreenState();
}

class _ExampleWidgetScreenState extends State<ExampleWidgetScreen> {
  final categoryStateHolder = CategoryStateHolder();
  var scrollController = ScrollController();
  bool isDarkTheme = false;
  bool isIOS = PlatformOverride.isIOS;
  ThemeData theme;

  TextTheme get textTheme => theme.textTheme;

  Widget wrapTheme(Widget child) {
    var wrap = child;
    if (!isIOS) {
      wrap = Material(
        child: child,
      );
    }
    return MaterialApp(
      theme: theme,
      home: wrap,
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        LocalizationStringWidget.delegate,
      ],
      supportedLocales: LocalizationStringWidget.delegate.supportedLocales,
      localeResolutionCallback: LocalizationStringWidget.delegate
          .resolution(fallback: new Locale("en", ""), withCountry: false),
    );
  }

  @override
  Widget build(BuildContext context) {
    PlatformOverride.setPlatform(isIOS);
    // ignore: invalid_use_of_protected_member
    if (scrollController.hasClients) {
      scrollController =
          ScrollController(initialScrollOffset: scrollController.offset);
    }
    theme = isDarkTheme ? AppTheme.darkTheme : AppTheme.theme;
    return MultiProvider(
      providers: [
        Provider(
          create: (_) => categoryStateHolder,
        ),
      ],
      child: wrapTheme(
        Scaffold(
          appBar: AppBar(
            actions: <Widget>[
              BackButton(
                onPressed: () => Navigator.pop(context),
              ),
              Expanded(
                child: SizedBox.shrink(),
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text("is IOS"),
                  Switch(
                    value: isIOS,
                    onChanged: (value) {
                      isIOS = value;
                      setState(() {});
                    },
                  ),
                ],
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text("is DarkTheme"),
                  Switch(
                    value: isDarkTheme,
                    onChanged: (value) {
                      isDarkTheme = value;
                      setState(() {});
                    },
                  ),
                ],
              ),
            ],
          ),
          body: ListView(
            controller: scrollController,
            children: <Widget>[
              AppCategory(),
              TextCategory(),
              FlutterCategory(),
            ],
          ),
        ),
      ),
    );
  }
}
