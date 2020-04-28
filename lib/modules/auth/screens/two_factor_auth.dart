import 'package:aurora_ui_kit/aurora_ui_kit.dart';
import 'package:aurorafiles/build_property.dart';
import 'package:aurorafiles/generated/s_of_context.dart';
import 'package:aurorafiles/modules/app_store.dart';
import 'package:aurorafiles/modules/auth/component/mail_logo.dart';
import 'package:aurorafiles/modules/auth/component/presentation_header.dart';
import 'package:aurorafiles/modules/files/files_route.dart';
import 'package:aurorafiles/shared_ui/app_input.dart';
import 'package:aurorafiles/shared_ui/main_gradient.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:theme/app_theme.dart';

class TwoFactorAuth extends StatefulWidget {
  @override
  _TwoFactorAuthState createState() => _TwoFactorAuthState();
}

class _TwoFactorAuthState extends State<TwoFactorAuth> {
  S s;
  final authState = AppStore.authState;
  final pinCtrl = TextEditingController();
  String error = "";
  var isProgress = false;

  @override
  Widget build(BuildContext context) {
    s = Str.of(context);
    final theme = Theme.of(context);
    final mq = MediaQuery.of(context);

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
                    Center(
                      child: Text(
                        s.two_factor_auth,
                        textAlign: TextAlign.center,
                        style: theme.textTheme.subhead.copyWith(
                          fontSize: 20,
                        ),
                      ),
                    ),
                    Column(
                      children: <Widget>[
                        AppInput(
                          labelText: s.pin,
                          inputCase: InputCase.Underline,
                          controller: pinCtrl,
                        ),
                        SizedBox(height: 10),
                        Text(
                          error,
                          style: TextStyle(color: Colors.red),
                        ),
                      ],
                    ),
                    Column(
                      children: <Widget>[
                        SizedBox(
                          width: double.infinity,
                          child: AMButton(
                            isLoading: isProgress,
                            child: Text(s.verify_pin),
                            onPressed: checkCode,
                          ),
                        ),
                        SizedBox(height: 6.0),
//                        SizedBox(
//                          width: double.infinity,
//                          child: AMButton(
//                            color: theme.colorScheme.surface,
//                            child: Text(s.cancel),
//                            onPressed: isProgress
//                                ? null
//                                : () => Navigator.pop(context),
//                          ),
//                        ),
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

  checkCode() {
    isProgress = true;
    error = "";
    setState(() {});
    final pin = pinCtrl.text;
    authState.twoFactorAuth(pin).then(
      (success) async {
        if (!success) {
          error = s.invalid_pin;
          return;
        }
        await authState.successLogin();
        Navigator.of(context).popUntil((Route<dynamic> route) {
          return route.isFirst;
        });
        Navigator.pushReplacementNamed(context, FilesRoute.name,
            arguments: FilesScreenArguments(path: ""));
      },
      onError: (e) {
        isProgress = false;
        error = e.toString();
        setState(() {});
      },
    );
  }
}
