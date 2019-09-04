import 'package:aurorafiles/modules/app_store.dart';
import 'package:aurorafiles/shared_ui/app_button.dart';
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
  void initState() {
    super.initState();
    _nameCtrl.text = AppStore.authState.userEmail;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Generate key")),
      body: Form(
        key: _generateKeyFormKey,
        child: ListView(
          padding: EdgeInsets.all(16.0),
          children: <Widget>[
            if (errMsg is String && errMsg.length > 0)
              Text(errMsg,
                  style: TextStyle(color: Theme.of(context).errorColor)),
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
              child: Text("GENERATE"),
              isLoading: _isGenerating,
              onPressed: () {
                if (!_generateKeyFormKey.currentState.validate()) return;
                errMsg = "";
                setState(() => _isGenerating = true);
                Navigator.of(context).pop();
              },
            ),
            FlatButton(
                child: Text("CANCEL"), onPressed: Navigator.of(context).pop),
          ],
        ),
      ),
    );
  }
}
