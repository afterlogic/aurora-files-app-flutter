import 'package:aurora_ui_kit/aurora_ui_kit.dart';
import 'package:aurorafiles/build_property.dart';
import 'package:aurorafiles/l10n/l10n.dart';
import 'package:aurorafiles/modules/auth/component/mail_logo.dart';
import 'package:aurorafiles/modules/auth/component/presentation_header.dart';
import 'package:aurorafiles/shared_ui/main_gradient.dart';
import 'package:flutter/material.dart';
import 'package:theme/app_theme.dart';

import 'package:aurorafiles/shared_ui/layout_config.dart';

class UpgradeAndroid extends StatelessWidget {
  final String message;

  const UpgradeAndroid(this.message, {super.key});

  Widget themeWidget(Widget widget) {
    if (AppTheme.login != null) {
      return Theme(
        data: AppTheme.login!,
        child: widget,
      );
    }
    return widget;
  }

  @override
  Widget build(BuildContext context) {
    final s = context.l10n;
    final theme = Theme.of(context);
    return themeWidget(
      Scaffold(
        body: LoginGradient(
          child: Stack(
            children: <Widget>[
              if (!BuildProperty.useMainLogo)
                const Positioned(
                  top: -70.0,
                  left: -70.0,
                  child: MailLogo(isBackground: true),
                ),
              Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(
                    maxWidth: LayoutConfig.formWidth,
                  ),
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 22.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        const PresentationHeader(
                          message: "",
                        ),
                        Text(
                          s.upgrade_your_plan,
                          style: const TextStyle(fontSize: 20),
                          textAlign: TextAlign.center,
                        ),
                        Column(
                          children: <Widget>[
                            const SizedBox(height: 6.0),
                            SizedBox(
                              width: double.infinity,
                              child: AMButton(
                                color: theme.colorScheme.surface,
                                onPressed: () => Navigator.of(context).pop(),
                                child: Text(s.back_to_login),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
