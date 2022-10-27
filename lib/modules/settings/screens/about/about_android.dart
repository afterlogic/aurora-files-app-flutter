import 'dart:io';

import 'package:aurorafiles/build_property.dart';
import 'package:aurorafiles/l10n/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:package_info/package_info.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:aurora_ui_kit/aurora_ui_kit.dart';

import 'package:aurorafiles/shared_ui/layout_config.dart';

class AboutAndroid extends StatefulWidget {
  const AboutAndroid({super.key});

  @override
  _AboutAndroidState createState() => _AboutAndroidState();
}

class _AboutAndroidState extends State<AboutAndroid> {
  bool loading = false;
  String _appName = '';
  String _version = '';

  @override
  void initState() {
    super.initState();
    _initAppInfo();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final isTablet = LayoutConfig.of(context).isTablet;
    if (!isTablet) {
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ]);
    }
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
    _version = _getPackageVersion(packageInfo.version, packageInfo.buildNumber);
    setState(() => loading = false);
  }

  String _getPackageVersion(String version, String build) {
    return Platform.isAndroid ? version : '$version+$build';
  }

  @override
  Widget build(BuildContext context) {
    final s = context.l10n;
    final isTablet = LayoutConfig.of(context).isTablet;
    return Scaffold(
      appBar: isTablet
          ? null
          : AMAppBar(
              title: Text(s.about),
            ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text(_appName, style: Theme.of(context).textTheme.headline6),
                const SizedBox(height: 12.0),
                Text(
                  s.version(_version),
                  style: Theme.of(context)
                      .textTheme
                      .caption
                      ?.copyWith(fontSize: 14.0),
                ),
                const SizedBox(height: 22.0),
                Center(
                  child: SizedBox(
                    width: 120.0,
                    height: 120.0,
                    child: Image.asset(BuildProperty.icon),
                  ),
                ),
                const SizedBox(height: 42.0),
                if (BuildProperty.termsOfService.isNotEmpty)
                  GestureDetector(
                    child: Text(
                      s.terms,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.secondary,
                        decoration: TextDecoration.underline,
                        fontSize: 18.0,
                      ),
                    ),
                    onTap: () => launchUrl(
                      Uri.parse(BuildProperty.termsOfService),
                    ),
                  ),
                const SizedBox(height: 22.0),
                if (BuildProperty.privacyPolicy.isNotEmpty)
                  GestureDetector(
                    child: Text(
                      s.privacy_policy,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.secondary,
                        decoration: TextDecoration.underline,
                        fontSize: 18.0,
                      ),
                    ),
                    onTap: () => launchUrl(
                      Uri.parse(BuildProperty.privacyPolicy),
                    ),
                  ),
                const SizedBox(height: 42.0),
              ],
            ),
    );
  }
}
