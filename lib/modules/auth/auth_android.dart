import 'package:aurora_ui_kit/aurora_ui_kit.dart';
import 'package:aurorafiles/build_property.dart';
import 'package:aurorafiles/l10n/l10n.dart';
import 'package:aurorafiles/modules/app_store.dart';
import 'package:aurorafiles/modules/auth/repository/auth_api.dart';
import 'package:aurorafiles/modules/auth/screens/fido_auth/fido_auth_route.dart';
import 'package:aurorafiles/modules/auth/screens/two_factor_auth/two_factor_auth_route.dart';
import 'package:aurorafiles/modules/auth/screens/upgrade_route.dart';
import 'package:aurorafiles/modules/files/files_route.dart';
import 'package:aurorafiles/override_platform.dart';
import 'package:aurorafiles/shared_ui/app_input.dart';
import 'package:aurorafiles/shared_ui/main_gradient.dart';
import 'package:aurorafiles/utils/input_validation.dart';
import 'package:aurorafiles/shared_ui/aurora_snack_bar.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';
import 'package:theme/app_theme.dart';

import 'component/auth_input.dart';
import 'component/mail_logo.dart';
import 'component/presentation_header.dart';
import 'package:aurorafiles/shared_ui/layout_config.dart';

import 'package:url_launcher/url_launcher.dart';

class AuthAndroid extends StatefulWidget {
  const AuthAndroid({super.key});

  @override
  _AuthAndroidState createState() => _AuthAndroidState();
}

class _AuthAndroidState extends State<AuthAndroid> {
  final _authFormKey = GlobalKey<FormState>();
  final _authState = AppStore.authState;
  late NavigatorState _navigator;
  bool _showHostField = false;
  bool _obscureText = true;

  @override
  void initState() {
    super.initState();
    _authState.isLoggingIn = false;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _authState.emailCtrl.text = _authState.userEmail ?? '';
      _authState.passwordCtrl.text = "";
    });
    _authState.lastEmail.then((value) {
      if (value != null) {
        _authState.emailCtrl.text = value;
      }
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final isTablet = LayoutConfig.of(context).isTablet;
    if (!isTablet) {
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ]);
    }
    _navigator = Navigator.of(context);
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
    final s = context.l10n;
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
        context: context,
        isFormValid: _authFormKey.currentState?.validate() ?? false,
        onTwoFactorAuth: (request) {
          if (request.hasSecurityKey == true && BuildProperty.useYubiKit) {
            _navigator.pushNamed(
              FidoAuthRoute.name,
              arguments: FidoAuthRouteArgs(
                false,
                request,
              ),
            );
          } else if (request.hasAuthenticatorApp == true) {
            _navigator.pushNamed(
              TwoFactorAuthRoute.name,
              arguments: TwoFactorAuthRouteArgs(
                false,
                request,
              ),
            );
          }
        },
        onSuccess: () async {
          _navigator.pushReplacementNamed(
            FilesRoute.name,
            arguments: FilesScreenArguments(path: ""),
          );
        },
        onShowUpgrade: (message) => _navigator.pushNamed(
          UpgradeRoute.name,
          arguments: UpgradeArg(message),
        ),
        onError: (String err) => AuroraSnackBar.showSnack(msg: err),
      );
      if (showHost) {
        if (!mounted) return;
//        _authState.hostCtrl.text = _authState.hostName;
        setState(() => _showHostField = true);
        AuroraSnackBar.showSnack(
          msg: s.enter_host,
          duration: const Duration(seconds: 6),
        );
      }
    } else {
      AuroraSnackBar.showSnack(msg: errMsg);
    }
  }
  Widget theme(Widget widget) {
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
    return Provider(
      create: (_) => _authState,
      child: theme(
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
                      child: Form(
                        key: _authFormKey,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            const Spacer(),
                            const PresentationHeader(),
                            const Spacer(),
                            Column(
                              children: <Widget>[
                                
                                Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.7),
                                    borderRadius: BorderRadius.circular(8),
                                    // border: Border.all(
                                    //   color: Colors.white.withOpacity(0.3),
                                    //   width: 1.0,
                                    // ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.15),
                                        blurRadius: 30.0,
                                        offset: const Offset(0, 4),
                                      ),
                                    ],
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 20.0,
                                    vertical: 36.0, 
                                  ),
                                  child: Column(
                                    children: _buildTextFields(),
                                    
                                  ),
                                ),

                                   
                                
                                
                                if (BuildProperty.registrationLink.isNotEmpty)
                                  const SizedBox(height: 30.0),
                                  _buildRegisterLink(),

                                const SizedBox(height: 50),
                              ]
                            ),
                            
                          ],
                        ),
                      ),
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
        onLongPress: () => _navigator.pushNamed(
          UpgradeRoute.name,
        ),
        onDoubleTap: () => _navigator.pushNamed(
          TwoFactorAuthRoute.name,
          arguments: TwoFactorAuthRouteArgs(false, RequestTwoFactor(true, true, true)),
        ),
        child: child,
      );
    } else {
      return child;
    }
  }

  Widget _buildRegisterLink() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        const Text(
          'Not account yet? ',
          style: TextStyle(
            color: Color(0xFF041844),
            fontSize: 18.0,
          ),
        ),
        GestureDetector(
          child: const Text(
            'Register now',
            style: TextStyle(
              color: Color(0xFF3975B5),
              fontSize: 18.0,
            ),
          ),
          onTap: () => launchUrl(Uri.parse(BuildProperty.registrationLink)),
        ),
      ],
    );
  }

  List<Widget> _buildTextFields() {
    final s = context.l10n;
    return [
      Align(
        alignment: Alignment.centerLeft,
        child: Text(
          'Sign in',
          textAlign: TextAlign.left,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontSize: 24.0,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
      ),
      const SizedBox(height: 10),
      if (_showHostField)
        AuthInput(
          labelText: s.host,
          controller: _authState.hostCtrl,
          keyboardType: TextInputType.url,
          // inputCase: InputCase.underline,
        ),
      const SizedBox(height: 10),
      AuthInput(
        labelText: s.email,
        controller: _authState.emailCtrl,
        keyboardType: TextInputType.emailAddress,
        validator: (value) => validateInput(
          value: value ?? '',
          types: [ValidationTypes.empty, ValidationTypes.email],
        ),
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
          color: Colors.black,
        ),
      ),
      const SizedBox(height: 10),
      AuthInput(
        labelText: s.password,
        controller: _authState.passwordCtrl,
        keyboardType: TextInputType.visiblePassword,
        validator: (value) => validateInput(
          value: value ?? '',
          types: [ValidationTypes.empty],
        ),
        obscureText: _obscureText,
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
          color: Colors.black,
        ),
        suffix: SizedBox(
          height: 50.0,
          child: IconButton(
            icon: Icon(
              _obscureText ? Icons.visibility : Icons.visibility_off,
              color: const Color(0xFF333333),
            ),
            onPressed: () => setState(() => _obscureText = !_obscureText),
          ),
        ),
      ),
      const SizedBox(height: 20),
      SizedBox(
        width: double.infinity,
        child: Observer(
          builder: (BuildContext context) => _debugRouteToTwoFactor(
            AMButton(
              color: Color(0xFF3975B5),
              radius: BorderRadius.circular(10.0),
              // shadow: AppColor.enableShadow ? null : BoxShadow(),
              shadow: const BoxShadow(),
              isLoading: _authState.isLoggingIn,
              onPressed: () => _login(context),
              child: Text(s.login),
            ),
          ),
        ),
      ),
    ];
  }
}
