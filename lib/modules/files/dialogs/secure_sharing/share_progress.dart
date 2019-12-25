import 'dart:io';
import 'dart:math';

import 'package:aurorafiles/database/app_database.dart';
import 'package:aurorafiles/generated/i18n.dart';
import 'package:aurorafiles/models/processing_file.dart';
import 'package:aurorafiles/models/recipient.dart';
import 'package:aurorafiles/modules/files/dialogs/secure_sharing/select_recipient.dart';
import 'package:aurorafiles/modules/files/repository/files_local_storage.dart';
import 'package:aurorafiles/modules/files/state/file_viewer_state.dart';
import 'package:aurorafiles/shared_ui/app_button.dart';
import 'package:aurorafiles/utils/show_snack.dart';
import 'package:crypto_plugin/crypto_plugin.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

class ShareProgress extends StatefulWidget {
  final FileViewerState _fileViewerState;
  final Recipient recipient;
  final LocalPgpKey pgpKey;
  final bool useKey;
  final Pgp pgp;
  final PreparedForShare file;
  final Function onLoad;

  const ShareProgress(
    this._fileViewerState,
    this.file,
    this.recipient,
    this.pgpKey,
    this.useKey,
    this.pgp,
    this.onLoad,
  );

  @override
  _ShareProgressState createState() => _ShareProgressState();
}

class _ShareProgressState extends State<ShareProgress> {
  Progress progress = Progress(1, 0);
  bool isDownload = false;
  File output;
  File temp;
  String link;
  S s;
  String error;

  encrypt() async {
    var isProgress = true;
    if (await output.exists()) await output.delete();
    if (await temp.exists()) await temp.delete();

    await widget.pgp.setTempFile(temp);
    await widget.pgp.setPublicKey(widget.pgpKey.key);
    widget.pgp.encryptFile(widget.file.file, output).then((_) {
      upload();
    }, onError: (e) {
      error = s.encrypt_error;
      setState(() {});
    }).whenComplete(() {
      isProgress = false;
    });
    while (isProgress) {
      progress = await widget.pgp.getProgress();
      if (isProgress) {
        setState(() {});
      }
      await Future.delayed(Duration(milliseconds: 500));
    }
  }

  upload() {
    isDownload = true;
    setState(() {});
    ProcessingFile _processingFile;
    widget._fileViewerState.uploadSecureFile(
      file: output,
      onUploadStart: (processingFile) {
        _processingFile = processingFile;
        processingFile.progressStream.listen((value) {
          progress = Progress(1, value);
          setState(() {});
        });
      },
      onSuccess: () {
        widget.onLoad();
        createPublicLink(_processingFile);
      },
      onError: (e) {
        error = e;
        setState(() {});
      },
    );
  }

  createPublicLink(ProcessingFile processingFile) {
    widget._fileViewerState.createPublicLink(
      processingFile: processingFile,
      onError: (e) {
        error = e;
        setState(() {});
      },
      onSuccess: (link) {
        this.link = link;
        setState(() {});
      },
    );
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
      if (link != null)
        FlatButton(
          child: Text(widget.useKey ? s.send_encrypted : s.send),
          onPressed: () {
            openEmail();
          },
        ),
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
          ...progressLabel(),
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

  openEmail() async {
    final uri = Uri.encodeFull(
        "mailto:${widget.recipient?.email ?? widget.pgpKey?.email}?subject=Secure share&body=$link");
    if (await canLaunch(uri)) {
      launch(uri);
    }
  }

  List<Widget> progressLabel() {
    final theme = Theme.of(context);
    if (error != null) {
      return [
        SizedBox(
          height: 20,
        ),
        Text(error),
        SizedBox(
          height: 10,
        ),
        Center(
          child: AppButton(
            onPressed: () {
              error = null;
              encrypt();
            },
            text: s.try_again,
          ),
        )
      ];
    }
    if (link == null) {
      return [
        Text(isDownload ? s.upload : s.encryption),
        LinearProgressIndicator(
          value: (progress?.current ?? 0) / (progress?.total ?? 1),
        ),
      ];
    }
    return [
      Text(s.encrypted_file_link),
      Padding(
        padding: EdgeInsets.symmetric(vertical: 10),
        child: Row(
          children: <Widget>[
            InkWell(
              child: Icon(Icons.content_copy),
              onTap: () {
                Clipboard.setData(ClipboardData(text: link));
              },
            ),
            SizedBox(width: 10),
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Text(link),
              ),
            )
          ],
        ),
      ),
      SizedBox(
        height: 10,
      ),
      Text(
        widget.useKey
            ? s.encrypted_using_key(widget.recipient?.fullName ??
                widget.recipient?.email ??
                widget.pgpKey?.email)
            : s.encrypted_using_password,
        style: theme.textTheme.caption,
      )
    ];
  }
}
