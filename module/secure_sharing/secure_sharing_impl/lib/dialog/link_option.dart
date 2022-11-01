import 'dart:math';

import 'package:aurorafiles/l10n/l10n.dart';
import 'package:aurorafiles/modules/settings/screens/pgp/dialog/import_key_dialog.dart';
import 'package:flutter/material.dart';

class LinkOptionWidget extends StatefulWidget {
  @override
  _LinkOptionWidgetState createState() => _LinkOptionWidgetState();
}

class _LinkOptionWidgetState extends State<LinkOptionWidget> {
  bool encryptLink = false;

  @override
  Widget build(BuildContext context) {
    final s = context.l10n;
    final size = MediaQuery.of(context).size;
    final title = Text(s.btn_shareable_link);
    final content = SizedBox(
        width: min(size.width - 40, 300),
        child: GestureDetector(
          onTap: () {
            encryptLink = !encryptLink;
            setState(() {});
          },
          child: Row(
            children: [
              CheckAnalog(
                encryptLink,
                (bool value) {
                  encryptLink = value;
                  setState(() {});
                },
              ),
              Expanded(
                child: Text(
                  s.encrypt_link,
                  maxLines: 2,
                ),
              ),
            ],
          ),
        ));

    final actions = <Widget>[
      TextButton(
        child: Text(encryptLink ? s.create_encrypt_link : s.create_link),
        onPressed: () {
          Navigator.pop(context, encryptLink);
        },
      ),
      TextButton(
        child: Text(s.cancel),
        onPressed: () {
          Navigator.pop(context);
        },
      )
    ];

    return AlertDialog(
      title: title,
      content: content,
      actions: actions,
    );
  }
}
