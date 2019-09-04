import 'package:aurorafiles/modules/app_store.dart';
import 'package:aurorafiles/shared_ui/app_button.dart';
import 'package:aurorafiles/utils/input_validation.dart';
import 'package:flutter/material.dart';

class ImportKeyDialog extends StatefulWidget {
  @override
  _ImportKeyDialogState createState() => _ImportKeyDialogState();
}

class _ImportKeyDialogState extends State<ImportKeyDialog> {
  final _keyCtrl = TextEditingController();
  final _nameCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  final _confirmPasswordCtrl = TextEditingController();
  final _importKeyFormKey = GlobalKey<FormState>();
  bool _isImporting = false;
  String errMsg = "";

  @override
  void initState() {
    super.initState();
    _nameCtrl.text = AppStore.authState.userEmail;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Import key from text")),
      body: Form(
              key: _importKeyFormKey,
              child: ListView(
                padding: EdgeInsets.all(16.0),
                children: <Widget>[
                  if (errMsg is String && errMsg.length > 0)
                    Text(errMsg,
                        style: TextStyle(color: Theme.of(context).errorColor)),
                  TextFormField(
                    controller: _keyCtrl,
                    autofocus: true,
                    decoration: InputDecoration(
                      icon: Icon(Icons.vpn_key),
                      labelText: "Key",
                      border: UnderlineInputBorder(),
                    ),
                    validator: (value) => validateInput(
                      value,
                      [ValidationTypes.empty],
                    ),
                  ),
                  SizedBox(height: 8.0),
                  TextFormField(
                    controller: _nameCtrl,
                    decoration: InputDecoration(
                      icon: Icon(Icons.title),
                      labelText: "Name",
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
                      labelText: "Password",
                      icon: Icon(Icons.lock),
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
                      labelText: "Confirm password",
                      icon: Icon(Icons.lock),
                      border: UnderlineInputBorder(),
                    ),
                    validator: (value) => validateInput(
                      value,
                      [ValidationTypes.empty],
                    ),
                  ),
                  SizedBox(height: 24.0),
                  AppButton(
                    child: Text("IMPORT"),
                    isLoading: _isImporting,
                    onPressed: _isImporting
                        ? null
                        : () {
                            if (!_importKeyFormKey.currentState.validate())
                              return;
                            errMsg = "";
                            setState(() => _isImporting = true);
//                            Navigator.of(context).pop();
                          },
                  ),
                  FlatButton(
                      child: Text("CANCEL"),
                      onPressed: Navigator.of(context).pop),
                ],
              ),
            ),
    );
  }
}
