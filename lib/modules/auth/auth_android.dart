import 'dart:io';

import 'package:aurorafiles/build_property.dart';
import 'package:aurorafiles/generated/s_of_context.dart';
import 'package:aurorafiles/modules/app_store.dart';
import 'package:aurorafiles/modules/auth/auth_data.dart';
import 'package:aurorafiles/modules/auth/screens/two_factor_auth_route.dart';
import 'package:aurorafiles/modules/auth/screens/upgrade_route.dart';
import 'package:aurorafiles/modules/auth/state/auth_state.dart';
import 'package:aurorafiles/modules/files/files_route.dart';
import 'package:aurorafiles/override_platform.dart';
import 'package:aurorafiles/shared_ui/app_button.dart';
import 'package:aurorafiles/shared_ui/app_input.dart';
import 'package:aurorafiles/shared_ui/main_gradient.dart';
import 'package:theme/app_theme.dart';
import 'package:aurorafiles/utils/input_validation.dart';
import 'package:aurorafiles/utils/show_snack.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';

class AuthAndroid extends StatefulWidget {
  @override
  _AuthAndroidState createState() => _AuthAndroidState();
}

class _AuthAndroidState extends State<AuthAndroid> {
  final _authFormKey = GlobalKey<FormState>();
  S s;
  AuthState _authState = AppStore.authState;
  bool _showHostField = false;
  bool _obscureText = true;

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    _authState.isLoggingIn = false;
    _authState.emailCtrl.text = _authState.userEmail;
    _authState.passwordCtrl.text = "";
    if (kDebugMode) {
      _authState.hostCtrl.text = AuthData.host;
      _authState.emailCtrl.text = AuthData.email;
      _authState.passwordCtrl.text = AuthData.password;
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

  Future _login(BuildContext context) async {
    String errMsg = "";
    if (PlatformOverride.isIOS) {
      if (_showHostField && _authState.hostCtrl.text.isEmpty) {
        errMsg = s.please_enter_hostname;
      } else if (_authState.emailCtrl.text.isEmpty) {
        errMsg = s.please_enter_email;
      } else if (_authState.passwordCtrl.text.isEmpty) {
        errMsg = s.please_enter_password;
      }
    }
    if (errMsg.isEmpty) {
      final showHost = await _authState.onLogin(
        isFormValid: _authFormKey.currentState.validate(),
        onTwoFactorAuth: () =>
            Navigator.pushNamed(context, TwoFactorAuthRoute.name),
        onSuccess: () async {
          await AppStore.settingsState.getUserEncryptionKeys();
          Navigator.pushReplacementNamed(context, FilesRoute.name,
              arguments: FilesScreenArguments(path: ""));
        },
        onShowUpgrade: () => Navigator.pushNamed(context, UpgradeRoute.name),
        onError: (String err) => showSnack(
          context: context,
          scaffoldState: Scaffold.of(context),
          msg: err,
        ),
      );
      if (showHost) {
        _authState.hostCtrl.text = _authState.hostName;
        setState(() => _showHostField = true);
        showSnack(
          context: context,
          scaffoldState: Scaffold.of(context),
          duration: Duration(seconds: 6),
          msg: s.enter_host,
        );
      }
    } else {
      showSnack(
        context: context,
        scaffoldState: Scaffold.of(context),
        msg: errMsg,
      );
    }
  }

  List<Widget> _buildTextFields() {
    final isIOS = PlatformOverride.isIOS;
    return [
      if (_showHostField)
        AppInput(
          inputCase: InputCase.Underline,
          style: TextStyle(color: Colors.white),
          controller: _authState.hostCtrl,
          keyboardType: TextInputType.url,
          validator: (value) => _showHostField
              ? validateInput(value, [ValidationTypes.empty])
              : "",
          labelText: s.host,
        ),
      SizedBox(height: 10),
      AppInput(
        style: TextStyle(color: Colors.white),
        controller: _authState.emailCtrl,
        prefix: isIOS
            ? Opacity(
                opacity: 0.6,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(0.0, 12.0, 8.0, 12.0),
                  child: Icon(Icons.email),
                ),
              )
            : null,
        keyboardType: TextInputType.emailAddress,
        validator: (value) => validateInput(
            value, [ValidationTypes.empty, ValidationTypes.email]),
        labelText: s.email,
        inputCase: InputCase.Underline,
      ),
      SizedBox(height: 10),
      AppInput(
        inputCase: InputCase.Underline,
        style: TextStyle(color: Colors.white),
        controller: _authState.passwordCtrl,
        validator: (value) => validateInput(value, [ValidationTypes.empty]),
        obscureText: _obscureText,
        labelText: s.password,
        prefix: isIOS
            ? Opacity(
                opacity: 0.6,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(0.0, 12.0, 8.0, 12.0),
                  child: Icon(
                    Icons.lock,
                  ),
                ),
              )
            : null,
        suffix: GestureDetector(
          child: Padding(
            padding: const EdgeInsets.only(top: 16.0),
            child: Icon(
              _obscureText ? Icons.visibility : Icons.visibility_off,
              color: Colors.white70,
            ),
          ),
          onTap: () => setState(() => _obscureText = !_obscureText),
        ),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    s = Str.of(context);
    final mq = MediaQuery.of(context);
    return Provider(
      create: (_) => _authState,
      child: Theme(
        data: AppTheme.darkTheme,
        child: Scaffold(
          body: MainGradient(
            child: SizedBox(
              height: mq.size.height - mq.viewInsets.bottom,
              width: mq.size.width,
              child: Center(
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(horizontal: 22.0),
                  child: Form(
                    key: _authFormKey,
                    child: Column(
                      children: <Widget>[
                        Hero(
                          tag: "logo",
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 32.0),
                            child: Image.asset(BuildProperty.main_logo),
                          ),
                        ),
                        SizedBox(height: 30.0),
                        ..._buildTextFields(),
                        SizedBox(height: 40.0),
                        SizedBox(
                          width: double.infinity,
                          child: Observer(
                            builder: (BuildContext context) => AppButton(
                              text: s.login,
                              buttonCase: ButtonCase.Filled,
                              isLoading: _authState.isLoggingIn,
                              onPressed: () => _login(context),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
