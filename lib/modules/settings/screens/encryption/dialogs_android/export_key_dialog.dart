import 'package:aurorafiles/utils/input_validation.dart';
import 'package:flutter/material.dart';

class ExportKeyDialog extends StatefulWidget {
  @override
  _ExportKeyDialogState createState() => _ExportKeyDialogState();
}

class _ExportKeyDialogState extends State<ExportKeyDialog> {
  final _passwordCtrl = TextEditingController();
  final _exportKeyFormKey = GlobalKey<FormState>();
  bool _isExporting = false;
  String errMsg = "";

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Export key"),
      content: _isExporting
          ? Row(
              children: <Widget>[
                CircularProgressIndicator(),
                SizedBox(width: 20.0),
                Text("Exporting the key...")
              ],
            )
          : Form(
              key: _exportKeyFormKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  if (errMsg is String && errMsg.length > 0)
                    Text(errMsg,
                        style: TextStyle(color: Theme.of(context).errorColor)),
                  TextFormField(
                    controller: _passwordCtrl,
                    obscureText: true,
                    autofocus: true,
                    decoration: InputDecoration(
                      hintText: "Enter password",
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
          child: Text("EXPORT"),
          onPressed: _isExporting
              ? null
              : () {
                  if (!_exportKeyFormKey.currentState.validate()) return;
                  errMsg = "";
                  setState(() => _isExporting = true);
                  Navigator.of(context).pop();
                },
        )
      ],
    );
  }
}
