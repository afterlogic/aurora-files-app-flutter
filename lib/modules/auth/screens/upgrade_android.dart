import 'dart:io';

import 'package:aurorafiles/build_property.dart';
import 'package:aurorafiles/generated/s_of_context.dart';
import 'package:aurorafiles/override_platform.dart';
import 'package:aurorafiles/shared_ui/app_button.dart';
import 'package:aurorafiles/shared_ui/main_gradient.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class UpgradeAndroid extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final s = Str.of(context);
    final mq = MediaQuery.of(context);
    final theme = Theme.of(context);
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
                      child: Image.asset(BuildProperty.mainLogo),
                    ),
                  ),
                  SizedBox(height: 90.0),
                  Text(
                    PlatformOverride.isIOS
                        ? s.upgrade_your_plan
                        : s.please_upgrade_your_plan,
                    style: theme.textTheme.subhead.copyWith(
                      fontSize: 20,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 70.0),
                  SizedBox(
                    width: double.infinity,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        if (!PlatformOverride.isIOS)
                          AppButton(
                            text: s.upgrade_now,
                            buttonCase: ButtonCase.Filled,
                            onPressed: () => launch(
                                "https://privatemail.com/members/clientarea.php?action=services"),
                          ),
                        SizedBox(height: 6.0),
                        AppButton(
                          text: s.back_to_login,
                          buttonCase: ButtonCase.Cancel,
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
