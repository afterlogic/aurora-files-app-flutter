import 'dart:io';

import 'package:aurorafiles/di/di.dart';
import 'package:aurorafiles/ui/assets/image.dart';
import 'package:aurorafiles/ui/locale/s.dart';
import 'package:aurorafiles/ui/themimg/material_theme.dart';
import 'package:aurorafiles/ui/view/app_button.dart';
import 'package:aurorafiles/ui/view/main_gradient.dart';
import 'package:aurorafiles/ui/view/screen.dart';
import 'package:aurorafiles/ui/view/show_snack.dart';
import 'package:aurorafiles/utils/input_validation.dart';
import 'package:aurorafiles/utils/platform_call.dart';
import 'package:domain/api/network/error/network_error.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import 'login_presenter.dart';
import 'login_view.dart';
import 'package:flutter/material.dart';
import 'package:mpv/mpv.dart';

class LoginWidget extends StatefulWidget {
  @override
  _LoginWidgetState createState() => _LoginWidgetState();
  static const heroLogo = "logo";
}

class _LoginWidgetState extends StateWithPresenter<LoginWidget, LoginPresenter>
    with LoginView, WithS {
  final _scaffold = GlobalKey<ScaffoldState>();
  final _authForm = GlobalKey<FormState>();
  final _host = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();
  bool _showHostField = false;
  bool _obscurePass = true;

  @override
  LoginPresenter createPresenter() => LoginPresenter(
        this,
        DI.get(),
        DI.get(),
        DI.get(),
        DI.get(),
      );

  @override
  void initState() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    if (kDebugMode) {
      debugAuth();
    }

    super.initState();
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context);
    return Theme(
      data: AppMaterialTheme.darkTheme,
      child: Scaffold(
        key: _scaffold,
        body: MainGradient(
          child: SizedBox(
            height: mq.size.height - mq.viewInsets.bottom,
            width: mq.size.width,
            child: Center(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 22.0),
                child: Form(
                  key: _authForm,
                  child: Column(
                    children: <Widget>[
                      Hero(
                        tag: LoginWidget.heroLogo,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 32.0),
                          child: Image.asset(AppAsset.logo),
                        ),
                      ),
                      SizedBox(height: 70.0),
                      ..._buildTextFields(),
                      SizedBox(height: 40.0),
                      SizedBox(
                        width: double.infinity,
                        child: StreamWidget(
                          progress,
                          (BuildContext context, state) => AppButton(
                            text: s.login,
                            buttonColor: Theme.of(context).accentColor,
                            textColor: Colors.white,
                            isLoading: state == true,
                            onPressed: state == true ? null : () => _login(),
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
    );
  }

  List<Widget> _buildTextFields() {
    if (Platform.isIOS) {
      return [
        if (_showHostField)
          CupertinoTextField(
            cursorColor: Theme.of(context).accentColor,
            controller: _host,
            keyboardType: TextInputType.url,
            decoration: BoxDecoration(
                border: Border(bottom: BorderSide(color: Colors.white38))),
            placeholder: s.host,
            autocorrect: false,
            prefix: Opacity(
              opacity: 0.6,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(0.0, 12.0, 8.0, 12.0),
                child: Icon(MdiIcons.web),
              ),
            ),
          ),
        SizedBox(height: 20),
        CupertinoTextField(
          cursorColor: Theme.of(context).accentColor,
          controller: _email,
          keyboardType: TextInputType.emailAddress,
          decoration: BoxDecoration(
              border: Border(bottom: const BorderSide(color: Colors.white38))),
          placeholder: s.email,
          autocorrect: false,
          prefix: Opacity(
            opacity: 0.6,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(0.0, 12.0, 8.0, 12.0),
              child: Icon(Icons.email),
            ),
          ),
        ),
        SizedBox(height: 20),
        CupertinoTextField(
          cursorColor: Theme.of(context).accentColor,
          controller: _password,
          decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: Colors.white38))),
          placeholder: s.password,
          obscureText: _obscurePass,
          autocorrect: false,
          prefix: Opacity(
            opacity: 0.6,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(0.0, 12.0, 8.0, 12.0),
              child: Icon(
                Icons.lock,
              ),
            ),
          ),
          suffix: IconButton(
            icon: Icon(
              _obscurePass ? Icons.visibility : Icons.visibility_off,
              color: Colors.white70,
            ),
            onPressed: () => setState(() => _obscurePass = !_obscurePass),
          ),
        ),
      ];
    } else {
      return [
        if (_showHostField)
          TextFormField(
            cursorColor: Theme.of(context).accentColor,
            controller: _host,
            keyboardType: TextInputType.url,
            validator: (value) => _showHostField
                ? validateInput(value, [ValidationTypes.empty])
                : "",
            decoration: InputDecoration(
              alignLabelWithHint: true,
              labelText: s.host,
            ),
          ),
        SizedBox(height: 10),
        TextFormField(
          cursorColor: Theme.of(context).accentColor,
          controller: _email,
          keyboardType: TextInputType.emailAddress,
          validator: (value) => validateInput(
              value, [ValidationTypes.empty, ValidationTypes.email]),
          decoration: InputDecoration(
            labelText: s.email,
            alignLabelWithHint: true,
          ),
        ),
        SizedBox(height: 10),
        TextFormField(
          cursorColor: Theme.of(context).accentColor,
          controller: _password,
          validator: (value) => validateInput(value, [ValidationTypes.empty]),
          obscureText: _obscurePass,
          decoration: InputDecoration(
            labelText: s.password,
            alignLabelWithHint: true,
            suffixIcon: GestureDetector(
              child: Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: Icon(
                  _obscurePass ? Icons.visibility : Icons.visibility_off,
                  color: Colors.white70,
                ),
              ),
              onTap: () => setState(() => _obscurePass = !_obscurePass),
            ),
          ),
        ),
      ];
    }
  }

  showError(Object errorCase, [String message]) {
    var _message = "";
    if (errorCase == NetworkErrorCase.InvalidLogin) {
      message = s.invalidLogin;
    } else {
      _message = message ?? s.tryAgain;
    }
    showSnack(
      context: context,
      scaffoldState: _scaffold.currentState,
      duration: Duration(seconds: 6),
      msg: _message,
    );
  }

  showHost() {
    setState(() => _showHostField = true);
    showSnack(
      context: context,
      scaffoldState: _scaffold.currentState,
      duration: Duration(seconds: 6),
      msg: s.hostRequired,
    );
  }

  setEmail(String email) {
    _email.text = email;
  }

  debugAuth() {
//    _host.text = "https://mail.privatemail.com";
    _email.text = "test@privatemail.tv";
    _password.text = "am9mW583yH?o";
  }

  _login() {
    bool validate;
    if (Platform.isIOS) {
      validate = iosValidate();
    } else {
      validate = _authForm.currentState.validate();
    }
    if (validate) {
      PlatformCall.hideTextInput();
      presenter.login(_host.text, _email.text, _password.text);
    }
  }

  validateField() {
    if (_showHostField && _host.text.isEmpty) {
      return s.enterHost;
    } else if (_host.text.isEmpty) {
      return s.enterEmail;
    } else if (_host.text.isEmpty) {
      return s.enterPassword;
    }

    return null;
  }

  bool iosValidate() {
    var message = validateField();
    if (message == null) {
      return true;
    } else {
      showSnack(
        context: context,
        scaffoldState: _scaffold.currentState,
        msg: message,
      );
      return false;
    }
  }
}
