import 'package:aurorafiles/database/app_database.dart';
import 'package:aurorafiles/models/recipient.dart';
import 'package:aurorafiles/modules/files/dialogs/secure_sharing/select_recipient.dart';
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
    return AlertDialog(
      content: ListView(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 10,
            ),
            child: Text("Secure sharing", style: theme.textTheme.title),
          ),
          SizedBox(
            height: 10,
          ),
          RecipientWidget(widget.recipient, widget.pgpKey),
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
      actions: <Widget>[
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
      ],
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
        Row(children: <Widget>[
          Radio(
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            value: true,
            groupValue: value,
            onChanged: onChanged,
          ),
          Text(
            "Key based",
            style: theme.textTheme.body1,
          ),
        ]),
        Divider(
          color: Colors.grey,
        ),
        Row(children: <Widget>[
          Radio(
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            value: false,
            groupValue: value,
            onChanged: onChanged,
          ),
          Text(
            "Password based",
            style: theme.textTheme.body1,
          ),
        ]),
        Divider(
          color: Colors.grey,
        ),
      ],
    );
  }
}

class SelectEncryptMethodResult {
  final bool useKey;

  SelectEncryptMethodResult(this.useKey);
}
