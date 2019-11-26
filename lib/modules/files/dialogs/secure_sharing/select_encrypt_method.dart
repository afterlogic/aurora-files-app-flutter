import 'dart:io';
import 'dart:math';

import 'package:aurorafiles/database/app_database.dart';
import 'package:aurorafiles/models/recipient.dart';
import 'package:aurorafiles/modules/files/dialogs/secure_sharing/select_recipient.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SelectEncryptMethod extends StatefulWidget {
  final Recipient recipient;
  final LocalPgpKey pgpKey;

  const SelectEncryptMethod(this.recipient, this.pgpKey);

  @override
  _SelectEncryptMethodState createState() => _SelectEncryptMethodState();
}

class _SelectEncryptMethodState extends State<SelectEncryptMethod> {
  bool useKey;

  @override
  void initState() {
    useKey = widget.pgpKey != null;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;
    final title = Text(
      "Secure sharing",
    );
    final content = SizedBox(
      height: min(size.height/2,350),
      child: ListView(
        children: <Widget>[
          RecipientWidget(RecipientWithKey(widget.recipient, widget.pgpKey)),
          SizedBox(
            height: 10,
          ),
          Text(
            useKey
                ? "Selected recipient has PGP public key. The file can be encrypted using this key."
                : "Selected recipient has no PGP public key. The key based encryption is not allowed.",
            style: theme.textTheme.caption,
          ),
          SizedBox(
            height: 20,
          ),
          Text(
            "Encryption type:",
            style: theme.textTheme.subtitle,
          ),
          RadioEncryptMethod(useKey, (v) {
            useKey = v;
            setState(() {});
          }),
          SizedBox(
            height: 10,
          ),
          Text(
            useKey
                ? "The Key based encryption will be used."
                : "The Password based encryption will be used.",
            style: theme.textTheme.caption,
          ),
        ],
      ),
    );

    final actions = <Widget>[
      FlatButton(
        child: Text("Encrypt"),
        onPressed: () {
          Navigator.pop(context, SelectEncryptMethodResult(useKey));
        },
      ),
      FlatButton(
        child: Text("Cancel"),
        onPressed: () {
          Navigator.pop(context);
        },
      )
    ];
    return Platform.isIOS
        ? CupertinoAlertDialog(
            title: title,
            content: content,
            actions: actions,
          )
        : AlertDialog(
            title: title,
            content: content,
            actions: actions,
          );
  }
}

class RadioEncryptMethod extends StatelessWidget {
  final bool value;
  final Function(bool) onChanged;

  RadioEncryptMethod(this.value, this.onChanged);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Divider(
          color: Colors.transparent,
        ),
        GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: value
              ? null
              : () {
                  onChanged(true);
                },
          child: Row(children: <Widget>[
            RadioAnalog(value),
            Text(
              "Key based",
              style: theme.textTheme.body1,
            ),
          ]),
        ),
        Divider(
          color: Colors.grey,
        ),
        GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: !value
              ? null
              : () {
                  onChanged(false);
                },
          child: Row(children: <Widget>[
            RadioAnalog(!value),
            Text(
              "Password based",
              style: theme.textTheme.body1,
            ),
          ]),
        ),
        Divider(
          color: Colors.grey,
        ),
      ],
    );
  }
}

class RadioAnalog extends StatelessWidget {
  final bool isCheck;

  const RadioAnalog(this.isCheck);

  @override
  Widget build(BuildContext context) {
    return Platform.isIOS
        ? Padding(
            padding: EdgeInsets.all(10),
            child: Icon(isCheck
                ? Icons.radio_button_checked
                : Icons.radio_button_unchecked),
          )
        : Radio(
            value: false,
            groupValue: !isCheck,
          );
  }
}

class SelectEncryptMethodResult {
  final bool useKey;

  SelectEncryptMethodResult(this.useKey);
}
