import 'dart:io';

import 'package:aurorafiles/build_const.dart';
import 'package:aurorafiles/generated/s_of_context.dart';
import 'package:aurorafiles/override_platform.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:package_info/package_info.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutAndroid extends StatefulWidget {
  @override
  _AboutAndroidState createState() => _AboutAndroidState();
}

class _AboutAndroidState extends State<AboutAndroid> {
  bool loading = false;
  String _appName;
  String _version;

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    _initAppInfo();
  }

  @override
  void dispose() {
    super.dispose();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
  }

  Future _initAppInfo() async {
    setState(() => loading = true);
    final packageInfo = await PackageInfo.fromPlatform();
    _appName = packageInfo.appName;
    _version = packageInfo.version+"+"+packageInfo.buildNumber;
    setState(() => loading = false);
  }

  @override
  Widget build(BuildContext context) {
    final s = Str.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(s.about),
      ),
      body: loading
          ? Center(child: CircularProgressIndicator())
          : Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Text(_appName, style: Theme
              .of(context)
              .textTheme
              .title),
          SizedBox(height: 12.0),
          Text(
            s.version(_version),
            style: Theme
                .of(context)
                .textTheme
                .caption
                .copyWith(fontSize: 14.0),
          ),
          SizedBox(height: 22.0),
          Center(
            child: SizedBox(
              width: 120.0,
              height: 120.0,
              child: Image.asset(BuildProperty.icon),
            ),
          ),
          SizedBox(height: 42.0),
          GestureDetector(
            child: Text(
              s.terms,
              style: TextStyle(
                color: Theme
                    .of(context)
                    .accentColor,
                decoration: TextDecoration.underline,
                fontSize: 18.0,
              ),
            ),
            onTap: () =>
                launch(PlatformOverride.isIOS
                    ? "https://privatemail.com/terms.php"
                    : "https://privatemail.com/terms.php"),
          ),
          SizedBox(height: 22.0),
          GestureDetector(
            child: Text(
              s.privacy_policy,
              style: TextStyle(
                color: Theme
                    .of(context)
                    .accentColor,
                decoration: TextDecoration.underline,
                fontSize: 18.0,
              ),
            ),
            onTap: () => launch("https://privatemail.com/privacy.php"),
          ),
          SizedBox(height: 42.0),
        ],
      ),
    );
  }
}
