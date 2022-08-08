import 'package:aurora_ui_kit/aurora_ui_kit.dart';
import 'package:aurorafiles/build_property.dart';
import 'package:aurorafiles/generated/s_of_context.dart';
import 'package:aurorafiles/modules/auth/auth_route.dart';
import 'package:aurorafiles/modules/auth/screens/backup_code_auth/backup_code_auth_route.dart';
import 'package:aurorafiles/modules/auth/screens/component/two_factor_screen.dart';
import 'package:aurorafiles/modules/auth/screens/fido_auth/fido_auth_route.dart';
import 'package:aurorafiles/modules/auth/screens/select_two_factor/select_two_factor_route.dart';
import 'package:aurorafiles/modules/auth/screens/two_factor_auth/two_factor_auth_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:aurora_ui_kit/components/am_button.dart';
import 'package:theme/app_theme.dart';

class SelectTwoFactorWidget extends StatefulWidget {
  final SelectTwoFactorRouteArgs args;

  const SelectTwoFactorWidget(this.args);

  @override
  _SelectTwoFactorWidgetState createState() => _SelectTwoFactorWidgetState();
}

class _SelectTwoFactorWidgetState extends State<SelectTwoFactorWidget> {
  late S s;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    s = Str.of(context);
  }

  @override
  Widget build(BuildContext context) {
    return TwoFactorScene(
      logoHint: "",
      isDialog: widget.args.isDialog,
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Text(
            s.tfa_label,
            style: Theme.of(context)
                .textTheme
                .headline6
                ?.copyWith(color: AppTheme.loginTextColor),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 10),
          Text(
            s.tfa_hint_step,
            textAlign: TextAlign.center,
            style: TextStyle(color: AppTheme.loginTextColor),
          ),
        ],
      ),
      buttons: [
        Text(
          s.tfa_label_hint_security_options,
          style: TextStyle(color: AppTheme.loginTextColor),
        ),
        SizedBox(height: 20),
        if (widget.args.state.hasSecurityKey && BuildProperty.useYubiKit) ...[
          SizedBox(
            width: double.infinity,
            child: AMButton(
              child: Text(
                s.tfa_btn_use_security_key,
                style: TextStyle(color: AppTheme.loginTextColor),
              ),
              onPressed: () {
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  FidoAuthRoute.name,
                  ModalRoute.withName(AuthRoute.name),
                  arguments: FidoAuthRouteArgs(
                      widget.args.isDialog, widget.args.state),
                );
              },
            ),
          ),
          SizedBox(height: 20)
        ],
        if (widget.args.state.hasAuthenticatorApp) ...[
          SizedBox(
            width: double.infinity,
            child: AMButton(
              child: Text(
                s.tfa_btn_use_auth_app,
                style: TextStyle(color: AppTheme.loginTextColor),
              ),
              onPressed: () {
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  TwoFactorAuthRoute.name,
                  ModalRoute.withName(AuthRoute.name),
                  arguments: TwoFactorAuthRouteArgs(
                      widget.args.isDialog, widget.args.state),
                );
              },
            ),
          ),
          SizedBox(height: 20)
        ],
        if (widget.args.state.hasBackupCodes) ...[
          SizedBox(
            width: double.infinity,
            child: AMButton(
              child: Text(
                s.tfa_btn_use_backup_code,
                style: TextStyle(color: AppTheme.loginTextColor),
              ),
              onPressed: () {
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  BackupCodeAuthRoute.name,
                  ModalRoute.withName(AuthRoute.name),
                  arguments: BackupCodeAuthRouteArgs(
                      widget.args.isDialog, widget.args.state),
                );
              },
            ),
          ),
        ],
      ],
    );
  }
}
