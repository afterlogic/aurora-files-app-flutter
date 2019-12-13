import 'dart:io';
import 'dart:math';

import 'package:aurorafiles/database/app_database.dart';
import 'package:aurorafiles/generated/i18n.dart';
import 'package:aurorafiles/models/recipient.dart';
import 'package:aurorafiles/modules/files/dialogs/secure_sharing/select_recipient.dart';
import 'package:aurorafiles/modules/files/repository/files_local_storage.dart';
import 'package:crypto_plugin/crypto_plugin.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ShareProgress extends StatefulWidget {
  final Recipient recipient;
  final LocalPgpKey pgpKey;
  final bool useKey;
  final Pgp pgp;
  final PreparedForShare file;

  const ShareProgress(
      this.file, this.recipient, this.pgpKey, this.useKey, this.pgp);

  @override
  _ShareProgressState createState() => _ShareProgressState();
}

class _ShareProgressState extends State<ShareProgress> {
  Progress progress = Progress(1, 0);
  File output;
  File temp;
  S s;

  encrypt() async {
    var isProgress = true;
    if (await output.exists()) await output.delete();
    if (await temp.exists()) await temp.delete();

    widget.pgp.setTempFile(temp);
    widget.pgp.setPublicKey(widget.pgpKey.key);
    widget.pgp.encryptFile(widget.file.file, output).then((_) {
      "";
    }, onError: (e) {
      e;
    }).whenComplete(() {
      isProgress = false;
    });
    while (isProgress) {
      progress = await widget.pgp.getProgress();
      setState(() {});
      await Future.delayed(Duration(seconds: 1));
    }
    progress = Progress(1, 1);
    setState(() {});
  }

  @override
  void initState() {
    temp = File(widget.file.file.path + ".temp");
    output = File(widget.file.file.path + ".pgp");
    encrypt();
    super.initState();
  }

  @override
  void dispose() {
    widget.pgp.stop().whenComplete(() async {
      if (await output.exists()) await output.delete();
      if (await temp.exists()) await temp.delete();
    });
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    s = S.of(context);
    final size = MediaQuery.of(context).size;
    final actions = <Widget>[
      FlatButton(
        child: Text(s.cancel),
        onPressed: () {
          Navigator.pop(context);
        },
      )
    ];
    final title = Padding(
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: Text(s.secure_sharing),
    );
    final content = SizedBox(
      height: min(size.height / 2, 350),
      child: ListView(
        children: <Widget>[
          SizedBox(
            height: 10,
          ),
          RecipientWidget(RecipientWithKey(widget.recipient, widget.pgpKey)),
          SizedBox(
            height: 10,
          ),
          Text(s.encryption),
          LinearProgressIndicator(
            value: (progress?.current ?? 0) / (progress?.total ?? 1),
          ),
          SizedBox(
            height: 20,
          ),
          Text(widget.useKey
              ? s.encrypted_using_key(widget.recipient.fullName)
              : s.encrypted_using_password,)
        ],
      ),
    );
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
