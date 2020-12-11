import 'package:aurora_ui_kit/aurora_ui_kit.dart';
import 'package:aurorafiles/build_property.dart';
import 'package:aurorafiles/generated/s_of_context.dart';
import 'package:aurorafiles/modules/app_store.dart';
import 'package:aurorafiles/modules/auth/auth_data.dart';
import 'package:aurorafiles/modules/auth/repository/auth_api.dart';
import 'package:aurorafiles/modules/auth/screens/fido_auth/fido_auth_route.dart';
import 'package:aurorafiles/modules/auth/screens/two_factor_auth/two_factor_auth_route.dart';
import 'package:aurorafiles/modules/auth/screens/upgrade_route.dart';
import 'package:aurorafiles/modules/auth/state/auth_state.dart';
import 'package:aurorafiles/modules/files/files_route.dart';
import 'package:aurorafiles/override_platform.dart';
import 'package:aurorafiles/shared_ui/app_input.dart';
import 'package:aurorafiles/shared_ui/main_gradient.dart';
import 'package:aurorafiles/utils/input_validation.dart';
import 'package:aurorafiles/utils/show_snack.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';
import 'package:theme/app_theme.dart';

import 'component/mail_logo.dart';
import 'component/presentation_header.dart';

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
    _authState.lastEmail.then((value) {
      if (value != null) {
        _authState.emailCtrl.text = value;
      }
    });
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
    // autodiscover field if it's hidden
//    if (!_showHostField) _authState.hostCtrl.clear();
    String errMsg = "";
    if (PlatformOverride.isIOS) {
      if (_authState.emailCtrl.text.isEmpty) {
        errMsg = s.please_enter_email;
      } else if (_authState.passwordCtrl.text.isEmpty) {
        errMsg = s.please_enter_password;
      }
    }
    if (errMsg.isEmpty) {
      final showHost = await _authState.onLogin(
        isFormValid: _authFormKey.currentState.validate(),
        onTwoFactorAuth: (request) {
          if (request.hasSecurityKey == true) {
            Navigator.pushNamed(
              context,
              FidoAuthRoute.name,
              arguments: FidoAuthRouteArgs(
                false,
                request,
              ),
            );
          } else if (request.hasAuthenticatorApp == true) {
            Navigator.pushNamed(
              context,
              TwoFactorAuthRoute.name,
              arguments: TwoFactorAuthRouteArgs(
                false,
                request,
              ),
            );
          }
        },
        onSuccess: () async {
          Navigator.pushReplacementNamed(context, FilesRoute.name,
              arguments: FilesScreenArguments(path: ""));
        },
        onShowUpgrade: (message) => Navigator.pushNamed(
          context,
          UpgradeRoute.name,
          arguments: UpgradeArg(message),
        ),
        onError: (String err) => showSnack(
          context: context,
          scaffoldState: Scaffold.of(context),
          msg: err,
        ),
      );
      if (showHost) {
//        _authState.hostCtrl.text = _authState.hostName;
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
          controller: _authState.hostCtrl,
          keyboardType: TextInputType.url,
          labelText: s.host,
        ),
      SizedBox(height: 10),
      AppInput(
        controller: _authState.emailCtrl,
        keyboardType: TextInputType.emailAddress,
        validator: (value) => validateInput(
            value, [ValidationTypes.empty, ValidationTypes.email]),
        labelText: s.email,
        inputCase: InputCase.Underline,
      ),
      SizedBox(height: 10),
      AppInput(
        inputCase: InputCase.Underline,
        controller: _authState.passwordCtrl,
        validator: (value) => validateInput(value, [ValidationTypes.empty]),
        obscureText: _obscureText,
        labelText: s.password,
        suffix: GestureDetector(
          child: Padding(
            padding: const EdgeInsets.only(top: 16.0),
            child: Icon(
              _obscureText ? Icons.visibility : Icons.visibility_off,
            ),
          ),
          onTap: () => setState(() => _obscureText = !_obscureText),
        ),
      ),
    ];
  }

  Widget theme(Widget widget) {
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
    s = Str.of(context);
    return Provider(
      create: (_) => _authState,
      child: theme(
        Scaffold(
          body: LoginGradient(
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
                  child: Form(
                    key: _authFormKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        PresentationHeader(),
                        Column(
                          children: _buildTextFields(),
                        ),
                        SizedBox(
                          width: double.infinity,
                          child: Observer(
                            builder: (BuildContext context) =>
                                _debugRouteToTwoFactor(
                              AMButton(
                                isLoading: _authState.isLoggingIn,
                                onPressed: () => _login(context),
                                child: Text(s.login),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _debugRouteToTwoFactor(Widget child) {
    if (kDebugMode) {
      return GestureDetector(
        onLongPress: () => Navigator.pushNamed(
          context,
          UpgradeRoute.name,
        ),
        onDoubleTap: () => Navigator.pushNamed(
          context,
          TwoFactorAuthRoute.name,
          arguments:
              TwoFactorAuthRouteArgs(false, RequestTwoFactor(true, true, true)),
        ),
        child: child,
      );
    } else {
      return child;
    }
  }
}
