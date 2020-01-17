import 'package:aurorafiles/generated/s_of_context.dart';
import 'package:aurorafiles/shared_ui/app_button.dart';
import 'package:aurorafiles/shared_ui/main_gradient.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class UpgradeAndroid extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final s = Str.of(context);
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
                    tag: "logo",
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 32.0),
                      child:
                      Image.asset("lib/assets/images/private-mail-logo.png"),
                    ),
                  ),
                  SizedBox(height: 90.0),
                  Text(
                    s.please_upgrade_your_plan,
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
                          text: s.upgrade_now,
                          buttonColor: Theme.of(context).accentColor,
                          textColor: Colors.white,
                          onPressed: () => launch(
                              "https://privatemail.com/members/clientarea.php?action=services"),
                        ),
                        SizedBox(height: 6.0),
                        AppButton(
                          text: s.back_to_login,
                          buttonColor: Color(0xFF54618d),
                          textColor: Colors.white,
                          onPressed: () => Navigator.of(context).pop(),
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
