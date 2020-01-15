import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:aurorafiles/database/app_database.dart';
import 'package:aurorafiles/generated/i18n.dart';
import 'package:aurorafiles/models/processing_file.dart';
import 'package:aurorafiles/models/recipient.dart';
import 'package:aurorafiles/modules/app_store.dart';
import 'package:aurorafiles/modules/files/dialogs/secure_sharing/select_recipient.dart';
import 'package:aurorafiles/modules/files/repository/files_local_storage.dart';
import 'package:aurorafiles/modules/files/state/file_viewer_state.dart';
import 'package:aurorafiles/modules/files/state/files_state.dart';
import 'package:aurorafiles/shared_ui/app_button.dart';
import 'package:aurorafiles/shared_ui/toast_widget.dart';
import 'package:aurorafiles/utils/mail_template.dart';
import 'package:aurorafiles/utils/pgp_key_util.dart';
import 'package:crypto_plugin/crypto_plugin.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class EncryptedShareLink extends StatefulWidget {
  final FilesState filesState;
  final FileViewerState _fileViewerState;
  final Recipient recipient;
  final LocalPgpKey pgpKey;
  final LocalPgpKey userPgpKey;
  final bool useKey;
  final bool useSign;
  final bool useEncrypt;
  final Pgp pgp;
  final PreparedForShare file;
  final Function onLoad;
  final String privateKeyPassword;

  const EncryptedShareLink(
    this._fileViewerState,
    this.userPgpKey,
    this.file,
    this.recipient,
    this.pgpKey,
    this.useKey,
    this.useSign,
    this.privateKeyPassword,
    this.pgp,
    this.onLoad,
    this.useEncrypt,
    this.filesState,
  );

  @override
  _EncryptedShareLinkState createState() => _EncryptedShareLinkState();
}

class _EncryptedShareLinkState extends State<EncryptedShareLink> {
  ProcessingFile _processingFile;
  double progress = 0;
  bool isDownload = false;
  bool sendProgress = false;

  File output;
  File temp;
  String link;
  S s;
  String error;
  String password;
  final toastKey = GlobalKey<ToastWidgetState>();

  encrypt() async {
    var isProgress = true;
    if (await output.exists()) await output.delete();
    if (await temp.exists()) await temp.delete();

    if (widget.useKey) {
      widget.pgp
          .encryptFile(
        widget.file.file,
        output,
        widget.privateKeyPassword,
      )
          .then((_) {
        upload();
      }, onError: (e) {
        error = s.encrypt_error;
        setState(() {});
      }).whenComplete(() {
        isProgress = false;
      });
    } else {
      password = PgpUtil.createSymmetricKey();
      widget.pgp.encryptSymmetricFile(widget.file.file, output, password).then(
          (_) {
        upload();
      }, onError: (e) {
        error = s.encrypt_error;
        setState(() {});
      }).whenComplete(() {
        isProgress = false;
      });
    }
    while (isProgress) {
      final pgpProgress = await widget.pgp.getProgress();
      progress =
          pgpProgress == null ? null : pgpProgress.current / pgpProgress.total;
      if (isProgress) {
        setState(() {});
      }
      await Future.delayed(Duration(milliseconds: 500));
    }
  }

  upload() {
    isDownload = true;
    final extend = !widget.useKey ? ".gpg" : ".pgp";
    setState(() {});

    widget._fileViewerState.uploadSecureFile(
      extend: extend,
      encryptionRecipientEmail: widget.recipient?.email ?? widget.pgpKey?.email,
      passwordEncryption: !widget.useKey,
      file: output,
      onUploadStart: (processingFile) {
        _processingFile = processingFile;
        processingFile.progressStream.listen((value) {
          progress = value;
          setState(() {});
        });
      },
      onSuccess: () {
        widget.onLoad();
        createPublicLink(_processingFile.fileOnDevice, extend);
      },
      onError: (e) {
        error = e;
        setState(() {});
      },
    );
  }

  createPublicLink(File file, String extend) {
    isDownload = true;
    setState(() {});
    if (widget.useEncrypt) {
      widget._fileViewerState.createPublicLink(
        extend: extend,
        onError: (e) {
          error = e;
          setState(() {});
        },
        onSuccess: (link) {
          this.link = link;
          setState(() {});
        },
      );
    } else {
      password = PgpUtil.createSymmetricKey();
      widget._fileViewerState.createSecureLink(
        password: password,
        extend: extend,
        onError: (e) {
          error = e;
          setState(() {});
        },
        onSuccess: (link) {
          this.link = link.link;
          setState(() {});
        },
      );
    }
  }

  share() async {
    if (widget.useEncrypt) {
      if (isDownload) {
        upload();
      } else {
        encrypt();
      }
    } else {
      createPublicLink(widget.file.file, "");
    }
  }

  prepare() async {
    if (widget.useEncrypt) {
      await widget.pgp.setTempFile(temp);
    }
    if (widget.pgpKey != null) {
      await widget.pgp.setPublicKey(widget.pgpKey.key);
    }
    if (widget.useSign == true) {
      await widget.pgp.setPrivateKey(widget.userPgpKey.key);
    }
    share();
  }

  @override
  void initState() {
    temp = File(widget.file.file.path + ".temp");
    output = File(widget.file.file.path + (!widget.useKey ? ".gpg" : ".pgp"));
    prepare();
    super.initState();
  }

  @override
  void dispose() {
    _processingFile?.endProcess();
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
          child: Text(widget.pgpKey != null ? s.send_encrypted : s.send),
          onPressed: sendProgress
              ? null
              : () {
                  sendEmail();
                },
        ),
      FlatButton(
        child: Text(s.cancel),
        onPressed: () {
          Navigator.pop(context);
        },
      )
    ];
    final title = Text(s.secure_sharing);
    final content = SizedBox(
      height: min(size.height / 2, 350),
      width: min(size.width - 40, 300),
      child: Stack(
        children: <Widget>[
          ListView(
            children: <Widget>[
              SizedBox(
                height: 10,
              ),
              RecipientWidget(
                  RecipientWithKey(widget.recipient, widget.pgpKey)),
              SizedBox(
                height: 10,
              ),
              ...progressLabel(),
            ],
          ),
          Align(
            alignment: Alignment(0, 1),
            child: ToastWidget(
              key: toastKey,
            ),
          ),
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

  sendEmail() async {
    sendProgress = true;
    setState(() {});
    toastKey.currentState.show(s.sending);
    final recipient = widget.recipient?.fullName ??
        widget.recipient?.email ??
        widget.pgpKey?.email;

    var template = MailTemplate.getTemplate(
      widget.useEncrypt,
      widget.useKey,
      widget.file.localFile.name,
      link,
      widget.pgpKey != null ? password : null,
      recipient,
      AppStore.authState.userEmail,
    );

    if (widget.pgpKey != null) {
      final encrypt = await widget.pgp.encryptBytes(
        Uint8List.fromList(template.body.codeUnits),
        widget.privateKeyPassword,
      );

      template.body = String.fromCharCodes(encrypt);
    }

    widget.filesState
        .sendViaEmail(template, widget.recipient?.email ?? widget.pgpKey?.email)
        .then(
      (_) {
        toastKey.currentState.show(s.sending_complete);
      },
      onError: (e) {
        toastKey.currentState.show(s.failed);
      },
    ).whenComplete(() {
      sendProgress = false;
      setState(() {});
    });
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

              share();
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
          value: Platform.isIOS && !isDownload ? null : progress,
        ),
      ];
    }
    return [
      ClipboardLabel(link, s.encrypted_file_link, () {
        toastKey.currentState.show(s.link_coppied_to_clipboard);
      }),
      SizedBox(
        height: 10,
      ),
      if (!widget.useKey)
        ClipboardLabel(password, s.encrypted_file_password, () {
          toastKey.currentState.show(s.link_coppied_to_clipboard);
        }),
      if (!widget.useKey) SizedBox(height: 10),
      Text(
        widget.useKey
            ? s.encrypted_using_key(widget.recipient?.fullName ??
                widget.recipient?.email ??
                widget.pgpKey?.email)
            : widget.pgpKey != null
                ? s.encrypted_using_password
                : s.copy_password,
        style: theme.textTheme.caption,
      )
    ];
  }
}

class ClipboardLabel extends StatefulWidget {
  final String link;
  final String description;
  final Function onTap;

  const ClipboardLabel(this.link, this.description, this.onTap);

  @override
  _ClipboardLabelState createState() => _ClipboardLabelState();
}

class _ClipboardLabelState extends State<ClipboardLabel> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        widget.onTap();
        Clipboard.setData(ClipboardData(text: widget.link));
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(widget.description),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Icon(Icons.content_copy),
                SizedBox(width: 10),
                Expanded(
                  child: Text(
                    widget.link,
                    maxLines: null,
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
