import 'dart:io';

import 'package:aurorafiles/generated/s_of_context.dart';
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
  final _lengthController =
   TextEditingController(text: lengths[1].toString());
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  S s;
  String _error;
  bool _obscure = true;
  static const lengths = [1024, 2048, 3072, 4096, 8192];
  var length = lengths[1];

  @override
  Widget build(BuildContext context) {
    s = Str.of(context);
    final title = Text(s.generate_keys);
    if (Platform.isIOS) {
      return CupertinoAlertDialog(
        title: title,
        content: SizedBox(
          child: Flex(
            direction: Axis.vertical,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(height: 10),
              CupertinoTextField(
                enabled: false,
                prefix: Padding(
                  padding: const EdgeInsets.only(left:8.0),
                  child: Text("${s.email}:"),
                ),
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
              ),
              SizedBox(height: 10),
              CupertinoTextField(
                autofocus: true,
                prefix: Padding(
                  padding: const EdgeInsets.only(left:8.0),
                  child: Text("${s.password}:"),
                ),
                suffix: GestureDetector(
                  child:
                  Padding(
                    padding: const EdgeInsets.only(right:8.0),
                    child: Icon(_obscure ? Icons.visibility : Icons.visibility_off),
                  ),
                  onTap: () {
                    _obscure = !_obscure;
                    setState(() {});
                  },
                ),
                obscureText: _obscure,
                controller: _passwordController,
                keyboardType: TextInputType.visiblePassword,
              ),
              SizedBox(height: 10),
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () {
                  showCupertinoModalPopup(
                      context: context,
                      builder: (_) {
                        return CupertinoActionSheet(
                            title: Text(s.select_length),
                            actions: lengths
                                .map((length) =>
                                CupertinoActionSheetAction(
                                  onPressed: () =>
                                      Navigator.pop(context, length),
                                  child: Text(length.toString()),
                                ))
                                .toList());
                      }).then((result) {
                    if (result is int) {
                      _lengthController.text=result.toString();
                      length = result;
                      setState(() {});
                    }
                  });
                },
                child: CupertinoTextField(
                  enabled: false,
                  prefix: Text(" ${s.length}: "),
                  controller:_lengthController,
                ),
              ),
              SizedBox(height: 10),
              Text(
                _error ?? "",
                style: TextStyle(color: Colors.red),
              ),
              AppButton(
                width: double.infinity,
                text: s.generate.toUpperCase(),
                onPressed: () {
                  if (_validateInput() == null) {
                    _generate();
                  }
                  setState(() {});
                },
              ),
              AppButton(
                width: double.infinity,
                text: s.close.toUpperCase(),
                onPressed: _pop,
              ),
            ],
          ),
        ),
      );
    } else {
      return AlertDialog(
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
                      enabled: false,
                      decoration: InputDecoration(labelText: s.email),
                      validator: (v) =>
                          validateInput(v, [ValidationTypes.email]),
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                    ),
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: s.password,
                        suffix: GestureDetector(
                          child: Icon(
                            _obscure ? Icons.visibility : Icons.visibility_off,
                          ),
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
                    DropdownButtonFormField(
                      hint: Text(length.toString()),
                      decoration: InputDecoration(labelText: s.email),
                      value: length,
                      items: lengths.map((value) {
                        return DropdownMenuItem<int>(
                          value: value,
                          child: Text(
                            value.toString(),
                          ),
                        );
                      }).toList(),
                      onChanged: (v) {
                        length = v;
                        setState(() {

                        });
                      },
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),
              AppButton(
                width: double.infinity,
                text: s.generate.toUpperCase(),
                onPressed: () {
                  if (_formKey.currentState.validate()) {
                    _generate();
                  }
                },
              ),
              AppButton(
                width: double.infinity,
                text: s.close.toUpperCase(),
                onPressed: _pop,
              ),
            ],
          ),
        ),
      );
    }
  }

  String _validateInput() {
    _error = null;
    _error = validateInput(_emailController.text, [ValidationTypes.email]);
    if (_error != null) return _error;
    _error = _validatePassword(_passwordController.text);
    return _error;
  }

  String _validatePassword(String text) {
    if (text.length < 1) {
      return s.password_is_empty;
    }
    return null;
  }

  _generate() async {
    final email = _emailController.text;
    final password = _passwordController.text;
    final hasKey = await widget.pgpKeyUtil.checkHasKey(_emailController.text);
    if (hasKey) {
      final result = await openDialog(
        context,
            (_) => ConfirmDeleteKeyWidget(s.already_have_key),
      );
      if (result != true) {
        return;
      }
      await widget.pgpKeyUtil.deleteByEmail([email]);
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
