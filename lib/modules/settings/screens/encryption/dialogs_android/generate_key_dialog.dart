import 'package:aurorafiles/utils/input_validation.dart';
import 'package:flutter/material.dart';

class GenerateKeyDialog extends StatefulWidget {
  @override
  _GenerateKeyDialogState createState() => _GenerateKeyDialogState();
}

class _GenerateKeyDialogState extends State<GenerateKeyDialog> {
  final _nameCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  final _confirmPasswordCtrl = TextEditingController();
  final _generateKeyFormKey = GlobalKey<FormState>();
  bool _isGenerating = false;
  String errMsg = "";

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Generate key"),
      content: _isGenerating
          ? Row(
              children: <Widget>[
                CircularProgressIndicator(),
                SizedBox(width: 20.0),
                Text("Generating a key...")
              ],
            )
          : Form(
              key: _generateKeyFormKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  if (errMsg is String && errMsg.length > 0)
                    Text(errMsg,
                        style: TextStyle(color: Theme.of(context).errorColor)),
                  TextFormField(
                    controller: _nameCtrl,
                    decoration: InputDecoration(
                      hintText: "Name",
                      isDense: true,
                      border: UnderlineInputBorder(),
                    ),
                    validator: (value) => validateInput(
                      value,
                      [ValidationTypes.empty],
                    ),
                  ),
                  SizedBox(height: 8.0),
                  TextFormField(
                    obscureText: true,
                    controller: _passwordCtrl,
                    decoration: InputDecoration(
                      isDense: true,
                      hintText: "Password",
                      border: UnderlineInputBorder(),
                    ),
                    validator: (value) => validateInput(
                      value,
                      [ValidationTypes.empty],
                    ),
                  ),
                  SizedBox(height: 8.0),
                  TextFormField(
                    obscureText: true,
                    controller: _confirmPasswordCtrl,
                    decoration: InputDecoration(
                      isDense: true,
                      hintText: "Confirm password",
                      border: UnderlineInputBorder(),
                    ),
                    validator: (value) => validateInput(
                      value,
                      [ValidationTypes.empty],
                    ),
                  ),
                ],
              ),
            ),
      actions: <Widget>[
        FlatButton(child: Text("CANCEL"), onPressed: Navigator.of(context).pop),
        FlatButton(
          child: Text("GENERATE"),
          onPressed: _isGenerating
              ? null
              : () {
                  if (!_generateKeyFormKey.currentState.validate()) return;
                  errMsg = "";
                  setState(() => _isGenerating = true);
                  Navigator.of(context).pop();
                },
        )
      ],
    );
  }
}
