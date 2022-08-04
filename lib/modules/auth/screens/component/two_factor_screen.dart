import 'package:aurorafiles/build_property.dart';
import 'package:aurorafiles/generated/s_of_context.dart';
import 'package:aurorafiles/generated/string/s.dart';
import 'package:aurorafiles/modules/auth/auth_route.dart';
import 'package:aurorafiles/modules/auth/component/mail_logo.dart';
import 'package:aurorafiles/modules/auth/component/presentation_header.dart';
import 'package:aurorafiles/shared_ui/layout_config.dart';
import 'package:aurorafiles/shared_ui/main_gradient.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:theme/app_theme.dart';

class TwoFactorScene extends StatefulWidget {
  final bool isDialog;
  final String logoHint;
  final Widget title;
  final List<Widget> button;
  final bool allowBack;

  const TwoFactorScene({
    Key? key,
    this.isDialog,
    this.logoHint,
    this.title,
    this.button,
    this.allowBack = true,
  }) : super(key: key);

  @override
  _SelectTwoFactorWidgetState createState() => _SelectTwoFactorWidgetState();
}

class _SelectTwoFactorWidgetState extends State<TwoFactorScene> {
  S s;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    s = Str.of(context);
  }

  Widget _gradientWrap(Widget child) {
    if (widget.isDialog) {
      return child;
    } else {
      return themeWrap(
        LoginGradient(
          child: child,
        ),
      );
    }
  }

  Widget themeWrap(Widget widget) {
    if (AppTheme.login != null) {
      return Theme(
        data: AppTheme.login,
        child: widget,
      );
    }
    return widget;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _gradientWrap(
        _buildPinForm(context),
      ),
    );
  }

  Widget _buildPinForm(BuildContext context) {
    return SafeArea(
      top: false,
      child: Stack(
        children: <Widget>[
          if (!widget.isDialog && !BuildProperty.useMainLogo)
            Positioned(
              top: -70.0,
              left: -70.0,
              child: MailLogo(isBackground: true),
            ),
          Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: LayoutConfig.formWidth,
              ),
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 22.0),
                child: Column(
                  mainAxisAlignment: widget.isDialog
                      ? MainAxisAlignment.start
                      : MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Spacer(),
                    if (!widget.isDialog) ...[
                      PresentationHeader(
                        message: widget.logoHint,
                      ),
                    ],
                    if (widget.isDialog) SizedBox(height: 40.0),
                    Flexible(
                      flex: 4,
                      child: ListView(
                        padding: EdgeInsets.zero,
                        children: [
                          widget.title ??
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Text(
                                    s.tfa_label,
                                    style: Theme.of(context)
                                        .textTheme
                                        .headline6
                                        .copyWith(
                                            color: AppTheme.loginTextColor),
                                    textAlign: TextAlign.center,
                                  ),
                                  SizedBox(height: 10),
                                  Text(
                                    s.tfa_hint_step,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: AppTheme.loginTextColor),
                                  ),
                                ],
                              ),
                          SizedBox(height: 20),
                          ...widget.button
                        ],
                      ),
                    ),
                    Flexible(
                      child: widget.allowBack
                          ? SizedBox(
                              width: double.infinity,
                              child: TextButton(
                                child: Text(
                                  s.btn_login_back_to_login,
                                  style:
                                      TextStyle(color: AppTheme.loginTextColor),
                                ),
                                onPressed: () {
                                  Navigator.popUntil(
                                    context,
                                    ModalRoute.withName(AuthRoute.name),
                                  );
                                },
                              ),
                            )
                          : SizedBox.shrink(),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
