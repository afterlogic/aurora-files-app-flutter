import 'dart:io';

import 'package:aurorafiles/modules/app_store.dart';
import 'package:aurorafiles/modules/settings/repository/pgp_key_util.dart';
import 'package:aurorafiles/modules/settings/screens/pgp/dialog/confirm_delete_key_widget.dart';
import 'package:aurorafiles/shared_ui/app_button.dart';
import 'package:aurorafiles/utils/input_validation.dart';
import 'package:aurorafiles/utils/open_dialog.dart';
import 'package:crypto_plugin/algorithm/pgp.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CreateKeyDialog extends StatefulWidget {
  final PgpKeyUtil pgpKeyUtil;

  CreateKeyDialog(this.pgpKeyUtil);

  @override
  _CreateKeyDialogState createState() => _CreateKeyDialogState();
}

class _CreateKeyDialogState extends State<CreateKeyDialog> {
  final _emailController =
      TextEditingController(text: AppStore.authState.userEmail);
  final _passwordController = TextEditingController();
  final _lengthController = TextEditingController(text: "2048");
  final _formKey = GlobalKey<FormState>();
  String _error;
  bool _obscure = true;

  @override
  Widget build(BuildContext context) {
    final title = Text("Generate keys");
    return Platform.isIOS
        ? CupertinoAlertDialog(
            title: title,
            content: SizedBox(
              child: Flex(
                direction: Axis.vertical,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(height: 10),
                  CupertinoTextField(
                    prefix: Text(" Email:"),
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                  ),
                  SizedBox(height: 10),
                  CupertinoTextField(
                    prefix: Text(" Password:"),
                    suffix: GestureDetector(
                      child: Icon(
                          _obscure ? Icons.visibility : Icons.visibility_off),
                      onTap: () {
                        _obscure = !_obscure;
                        setState(() {});
                      },
                    ),
                    obscureText: _obscure,
                    controller: _passwordController,
                    keyboardType: TextInputType.visiblePassword,
                    inputFormatters: [
                      WhitelistingTextInputFormatter.digitsOnly
                    ],
                  ),
                  SizedBox(height: 10),
                  CupertinoTextField(
                    prefix: Text(" Length:"),
                    controller: _lengthController,
                    keyboardType: TextInputType.number,
                  ),
                  SizedBox(height: 10),
                  Text(
                    _error ?? "",
                    style: TextStyle(color: Colors.red),
                  ),
                  AppButton(
                    width: double.infinity,
                    text: "Generate".toUpperCase(),
                    onPressed: () {
                      if (_validateInput() == null) {
                        _generate();
                      }
                      setState(() {});
                    },
                  ),
                  AppButton(
                    width: double.infinity,
                    text: "Close".toUpperCase(),
                    onPressed: _pop,
                  ),
                ],
              ),
            ),
          )
        : AlertDialog(
            title: title,
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Form(
                    key: _formKey,
                    child: Column(
                      children: <Widget>[
                        TextFormField(
                          decoration: const InputDecoration(labelText: "Email"),
                          validator: (v) =>
                              validateInput(v, [ValidationTypes.email]),
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                        ),
                        TextFormField(
                          decoration:  InputDecoration(
                            labelText: "Password",
                            suffix: GestureDetector(
                              child: Icon(_obscure
                                  ? Icons.visibility
                                  : Icons.visibility_off,),
                              onTap: () {
                                _obscure = !_obscure;
                                setState(() {});
                              },
                            ),
                          ),
                          validator: (v) =>
                              validateInput(v, [ValidationTypes.empty]),
                          controller: _passwordController,
                          obscureText: _obscure,
                        ),
                        TextFormField(
                          decoration:
                              const InputDecoration(labelText: "Length"),
                          validator: (value) {
                            return _validateLength(value);
                          },
                          inputFormatters: [
                            WhitelistingTextInputFormatter.digitsOnly
                          ],
                          controller: _lengthController,
                          keyboardType: TextInputType.numberWithOptions(
                              signed: true, decimal: false),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  AppButton(
                    width: double.infinity,
                    text: "Generate".toUpperCase(),
                    onPressed: () {
                      if (_formKey.currentState.validate()) {
                        _generate();
                      }
                    },
                  ),
                  AppButton(
                    width: double.infinity,
                    text: "Close".toUpperCase(),
                    onPressed: _pop,
                  ),
                ],
              ),
            ),
          );
  }

  String _validateInput() {
    _error = null;
    _error = validateInput(_emailController.text, [ValidationTypes.email]);
    if (_error != null) return _error;
    _error = _validatePassword(_passwordController.text);
    if (_error != null) return _error;
    _error = _validateLength(_lengthController.text);
    return _error;
  }

  String _validatePassword(String text) {
    if (text.length < 1) {
      return "password is empty";
    }
    return null;
  }

  String _validateLength(String text) {
    final length = int.tryParse(text);
    if (length == null) {
      return "invalid";
    }
    if (length > 4096 || length < 512) {
      return "set length between 512..4096";
    }
    return null;
  }

  _generate() async {
    final length = int.tryParse(_lengthController.text);
    final email = _emailController.text;
    final password = _passwordController.text;
    final hasKey = await widget.pgpKeyUtil.checkHasKey(_emailController.text);
    if (hasKey) {
      final result = await openDialog(
        context,
        (_) => ConfirmDeleteKeyWidget(
            "You already have the key(s) for this email"),
      );
      if (result != true) {
        return;
      }
    }

    final future = widget.pgpKeyUtil.createKeys(length, email, password);
    Navigator.pop(context, CreateKeyResult(email, length, future, hasKey));
  }

  _pop() {
    Navigator.pop(context);
  }
}

class CreateKeyResult {
  final String email;
  final int length;
  final Future<KeyPair> keyBuilder;
  final bool needUpdate;

  CreateKeyResult(this.email, this.length, this.keyBuilder, this.needUpdate);
}
