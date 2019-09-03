import 'package:aurorafiles/modules/auth/state/auth_state.dart';
import 'package:aurorafiles/modules/files/files_route.dart';
import 'package:aurorafiles/modules/files/state/files_state.dart';
import 'package:aurorafiles/shared_ui/main_gradient.dart';
import 'package:aurorafiles/shared_ui/app_button.dart';
import 'package:aurorafiles/utils/input_validation.dart';
import 'package:aurorafiles/utils/show_snack.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

class AuthAndroid extends StatefulWidget {
  static final _authFormKey = GlobalKey<FormState>();

  @override
  _AuthAndroidState createState() => _AuthAndroidState();
}

class _AuthAndroidState extends State<AuthAndroid> {
  AuthState authState;

  @override
  void initState() {
    super.initState();
    authState = AuthState();
  }

  @override
  void dispose() {
    super.dispose();
    authState.dispose();
  }

  @override
  Widget build(BuildContext context) {
//    authState = Provider.of<AuthState>(context);
  
    return Scaffold(
      body: MainGradient(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16.0),
          child: SizedBox(
            // height - padding
            height: MediaQuery.of(context).size.height - 32.0,
            width: MediaQuery.of(context).size.width,
            child: Form(
              key: AuthAndroid._authFormKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text("Login", style: Theme.of(context).textTheme.display1),
                  SizedBox(height: 23.0),
                  TextFormField(
                    cursorColor: Theme.of(context).primaryColor,
                    controller: authState.emailCtrl,
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) => validateInput(
                        value, [ValidationTypes.empty, ValidationTypes.email]),
                    decoration: InputDecoration(
                      hintText: "Email",
                      icon: Icon(Icons.email),
                    ),
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    cursorColor: Theme.of(context).primaryColor,
                    controller: authState.passwordCtrl,
                    validator: (value) =>
                        validateInput(value, [ValidationTypes.empty]),
                    obscureText: true,
                    decoration: InputDecoration(
                      hintText: "Password",
                      icon: Icon(Icons.lock),
                    ),
                  ),
                  SizedBox(height: 30),
                  SizedBox(
                    width: double.infinity,
                    child: Observer(
                      builder: (BuildContext context) => AppButton(
                        child: Text("LOGIN"),
                        isLoading: authState.isLoggingIn,
                        onPressed: () => authState.onLogin(
                          isFormValid:
                              AuthAndroid._authFormKey.currentState.validate(),
                          onSuccess: () => Navigator.pushReplacementNamed(
                              context, FilesRoute.name,
                              arguments: FilesScreenArguments(
                                  path: "", filesState: FilesState())),
                          onError: (String err) => showSnack(
                            context: context,
                            scaffoldState: Scaffold.of(context),
                            msg: err,
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
      ),
    );
  }
}
