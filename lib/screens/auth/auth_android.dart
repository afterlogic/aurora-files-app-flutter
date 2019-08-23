import 'package:aurorafiles/screens/auth/state/auth_state.dart';
import 'package:aurorafiles/screens/files/files_route.dart';
import 'package:aurorafiles/screens/files/state/files_state.dart';
import 'package:aurorafiles/shared_ui/my_button.dart';
import 'package:aurorafiles/utils/input_validation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';

class AuthAndroid extends StatefulWidget {
  static final _authFormKey = GlobalKey<FormState>();

  @override
  _AuthAndroidState createState() => _AuthAndroidState();
}

class _AuthAndroidState extends State<AuthAndroid> {
  AuthState authState;

  @override
  void initState() {
    authState = AuthState();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    authState.dispose();
  }

  void _showErrSnackBar(BuildContext context, String text) {
    final snackbar = SnackBar(
      content: Text(
        text,
        style: TextStyle(color: Colors.white),
      ),
      backgroundColor: Theme.of(context).errorColor,
    );

    Scaffold.of(context).showSnackBar(snackbar);
  }

  @override
  Widget build(BuildContext context) {
    return Provider<AuthState>(
      builder: (_) => authState,
      child: Scaffold(
        body: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              stops: [0, 1],
              colors: [
                Color.fromRGBO(130, 212, 210, 1),
                Color.fromRGBO(10, 132, 178, 1),
              ],
            ),
          ),
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Form(
              key: AuthAndroid._authFormKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
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
                      builder: (BuildContext context) => MyButton(
                        isLoading: authState.isLoggingIn,
                        onPressed: () => authState.onLogin(
                          isFormValid:
                              AuthAndroid._authFormKey.currentState.validate(),
                          onSuccess: () => Navigator.pushReplacementNamed(
                              context, FilesRoute.name,
                              arguments: FilesScreenArguments(
                                  path: "", filesState: FilesState())),
                          onError: (errText) =>
                              _showErrSnackBar(context, errText),
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
