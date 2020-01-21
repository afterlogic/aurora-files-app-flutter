import 'dart:io';

import 'package:aurorafiles/generated/s_of_context.dart';
import 'package:aurorafiles/modules/app_store.dart';
import 'package:aurorafiles/modules/files/files_route.dart';
import 'package:aurorafiles/shared_ui/app_button.dart';
import 'package:aurorafiles/shared_ui/main_gradient.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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

    return Scaffold(
      body: MainGradient(
        child: SizedBox(
          height: mq.size.height - mq.viewInsets.bottom,
          width: mq.size.width,
          child: Center(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 22.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Hero(
                    tag: "logo",
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 32.0),
                      child: Image.asset(
                          "lib/assets/images/private-mail-logo.png"),
                    ),
                  ),
                  SizedBox(height: 70.0),
                  Center(
                    child: Text(
                      s.two_factor_auth,
                      textAlign: TextAlign.center,
                      style: theme.textTheme.subhead.copyWith(fontSize: 20),
                    ),
                  ),
                  SizedBox(height: 40.0),
                  if (Platform.isIOS)
                    CupertinoTextField(
                      placeholder: s.pin,
                      controller: pinCtrl,
                    ),
                  if (!Platform.isIOS)
                    TextFormField(
                      decoration: InputDecoration(labelText: s.pin),
                      controller: pinCtrl,
                    ),
                  SizedBox(height: 10),
                  Text(
                    error,
                    style: TextStyle(color: Colors.red),
                  ),
                  SizedBox(height: 40.0),
                  AppButton(
                    isLoading: isProgress,
                    width: double.infinity,
                    text: s.verify_pin,
                    onPressed: checkCode,
                  ),
                  AppButton(
                    buttonColor: Color.fromARGB(255, 85, 97, 140),
                    width: double.infinity,
                    text: s.cancel,
                    onPressed: isProgress ? null : () => Navigator.pop(context),
                  )
                ],
              ),
            ),
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
        await AppStore.settingsState.getUserEncryptionKeys();
        Navigator.pushReplacementNamed(context, FilesRoute.name,
            arguments: FilesScreenArguments(path: ""));
      },
      onError: (e) {
        error = e.toString();
      },
    ).whenComplete(() {
      isProgress = false;
      setState(() {});
    });
  }
}
