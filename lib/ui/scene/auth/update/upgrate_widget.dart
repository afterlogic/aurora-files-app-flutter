import 'package:aurorafiles/ui/assets/image.dart';
import 'package:aurorafiles/ui/locale/s.dart';
import 'package:aurorafiles/ui/scene/auth/login/login_widget.dart';
import 'package:aurorafiles/ui/view/app_button.dart';
import 'package:aurorafiles/ui/view/main_gradient.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:flutter/material.dart';

class UpgradeWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final mq = MediaQuery.of(context);
    return Scaffold(
      body: MainGradient(
        child: SizedBox(
          height: mq.size.height - mq.viewInsets.bottom,
          width: mq.size.width,
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 22.0),
              child: Column(
                children: <Widget>[
                  Hero(
                    tag: LoginWidget.heroLogo,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 32.0),
                      child: Image.asset(AppAsset.logo),
                    ),
                  ),
                  SizedBox(height: 90.0),
                  Text(
                    s.upgradeText,
                    style: TextStyle(fontSize: 20.0),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 70.0),
                  SizedBox(
                    width: double.infinity,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        AppButton(
                          text: s.upgradeNow,
                          buttonColor: Theme.of(context).accentColor,
                          textColor: Colors.white,
                          onPressed: () => launch(
                              "https://privatemail.com/members/clientarea.php?action=services"),
                        ),
                        SizedBox(height: 6.0),
                        AppButton(
                          text: s.backToLogin,
                          buttonColor: Color(0xFF54618d),
                          textColor: Colors.white,
                          onPressed: () => Navigator.pop(context),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
