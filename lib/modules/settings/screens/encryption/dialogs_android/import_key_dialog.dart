import 'package:aurorafiles/utils/input_validation.dart';
import 'package:flutter/material.dart';

class ImportKeyDialog extends StatefulWidget {
  @override
  _ImportKeyDialogState createState() => _ImportKeyDialogState();
}

class _ImportKeyDialogState extends State<ImportKeyDialog> {
  final _keyCtrl = TextEditingController();
  final _importKeyFormKey = GlobalKey<FormState>();
  bool _isImporting = false;
  String errMsg = "";

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Import key"),
      content: _isImporting
          ? Row(
              children: <Widget>[
                CircularProgressIndicator(),
                SizedBox(width: 20.0),
                Text("Importing the key...")
              ],
            )
          : Form(
              key: _importKeyFormKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  if (errMsg is String && errMsg.length > 0)
                    Text(errMsg,
                        style: TextStyle(color: Theme.of(context).errorColor)),
                  TextFormField(
                    controller: _keyCtrl,
                    autofocus: true,
                    decoration: InputDecoration(
                      hintText: "Enter key",
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
          child: Text("IMPORT"),
          onPressed: _isImporting
              ? null
              : () {
                  if (!_importKeyFormKey.currentState.validate()) return;
                  errMsg = "";
                  setState(() => _isImporting = true);
                  Navigator.of(context).pop();
                },
        )
      ],
    );
  }
}
