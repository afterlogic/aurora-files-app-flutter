import 'package:aurora_ui_kit/aurora_ui_kit.dart';
import 'package:aurorafiles/build_property.dart';
import 'package:aurorafiles/generated/s_of_context.dart';
import 'package:aurorafiles/modules/auth/component/mail_logo.dart';
import 'package:aurorafiles/modules/auth/component/presentation_header.dart';
import 'package:aurorafiles/override_platform.dart';
import 'package:aurorafiles/shared_ui/main_gradient.dart';
import 'package:flutter/material.dart';
import 'package:theme/app_theme.dart';
import 'package:url_launcher/url_launcher.dart';

class UpgradeAndroid extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final s = Str.of(context);
    final mq = MediaQuery.of(context);
    final theme = Theme.of(context);
    return Theme(
      data: AppTheme.login,
      child: Scaffold(
        body: MainGradient(
          child: Stack(
            children: <Widget>[
              if (!BuildProperty.useMainLogo)
                Positioned(
                  top: -70.0,
                  left: -70.0,
                  child: MailLogo(isBackground: true),
                ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 22.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    PresentationHeader(
                      message: "",
                    ),
                    Text(
                      PlatformOverride.isIOS
                          ? s.upgrade_your_plan
                          : s.please_upgrade_your_plan,
                      style: theme.textTheme.subhead.copyWith(
                        fontSize: 20,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    Column(
                      children: <Widget>[
                        if (!PlatformOverride.isIOS)
                          SizedBox(
                            width: double.infinity,
                            child: AMButton(
                              child: Text(s.upgrade_now),
                              onPressed: () => launch(
                                  "https://privatemail.com/members/clientarea.php?action=services"),
                            ),
                          ),
                        SizedBox(height: 6.0),
                        SizedBox(
                          width: double.infinity,
                          child: AMButton(
                            child: Text(s.back_to_login),
                            color: theme.colorScheme.surface,
                            onPressed: () => Navigator.of(context).pop(),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
