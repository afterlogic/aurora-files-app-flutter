import 'dart:io';
import 'dart:math';

import 'package:aurora_ui_kit/aurora_ui_kit.dart';
import 'package:aurorafiles/database/app_database.dart';
import 'package:aurorafiles/l10n/l10n.dart';
import 'package:aurorafiles/models/recipient.dart';
import 'package:aurorafiles/modules/app_store.dart';
import 'package:aurorafiles/modules/files/dialogs/key_request_dialog.dart';
import 'package:aurorafiles/modules/files/repository/files_local_storage.dart';
import 'package:aurorafiles/modules/files/state/files_state.dart';
import 'package:aurorafiles/modules/settings/repository/pgp_key_util.dart';
import 'package:aurorafiles/shared_ui/toast_widget.dart';
import 'package:aurorafiles/utils/mail_template.dart';
import 'package:aurorafiles/utils/pgp_key_util.dart';
import 'package:crypto_stream/algorithm/pgp.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

import 'legacy_pgp_api.dart';
import 'select_recipient.dart';

class EncryptedShareLink extends StatefulWidget {
  final FilesState filesState;
  final Recipient? recipient;
  final LocalPgpKey? pgpKey;
  final LocalPgpKey? userPrivateKey;
  final LocalPgpKey? userPublicKey;
  final bool useKey;
  final bool useSign;
  final bool useEncrypt;
  final Pgp pgp;
  final PreparedForShare file;
  final Function onLoad;
  final String privateKeyPassword;

  const EncryptedShareLink(
    this.userPrivateKey,
    this.userPublicKey,
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
  late LegacyPgpApi legacyPgpApi;
  double progress = 0;
  bool isDownload = false;
  bool sendProgress = false;
  String? link;
  String? error;
  String password = '';
  final toastKey = GlobalKey<ToastWidgetState>();

  Future<void> encrypt(BuildContext context) async {
    final s = context.l10n;
    if (widget.useKey) {
      widget.filesState.addDecryptedPublicKey(
          context, widget.file.localFile, [widget.pgpKey?.key ?? '']).then((_) {
        upload();
      }, onError: (e) {
        error = s.encrypt_error;
        setState(() {});
      });
    } else {
      password = PgpUtil.createSymmetricKey();
      final pgpPassword = await KeyRequestDialog.request(context);
      if (pgpPassword == null) {
        error = "";
        setState(() {});
      }
      final key = (await PgpKeyUtil.instance.userDecrypt(
          widget.file.localFile.encryptedDecryptionKey, pgpPassword));

      widget.filesState
          .addDecryptedPublicPassword(
        context,
        widget.file.localFile,
        await legacyPgpApi.encryptSymmetric(key, password),
      )
          .then((_) {
        upload();
      }, onError: (e) {
        error = s.encrypt_error;
        setState(() {});
      });
    }
  }

  void upload() {
    isDownload = true;
    widget.onLoad();
    createPublicLink();
  }

  void createPublicLink() {
    isDownload = true;
    setState(() {});

    widget.filesState.createSecureLink(
      file: widget.file.localFile,
      email: widget.recipient?.email ?? '',
      isKey: widget.useKey,
      password: widget.useEncrypt ? "" : password,
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

  Future<void> share(BuildContext context) async {
    if (widget.useEncrypt) {
      if (isDownload) {
        upload();
      } else {
        encrypt(context);
      }
    } else {
      createPublicLink();
    }
  }

  @override
  void initState() {
    _prepare();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      share(context);
    });
    super.initState();
  }

  static Future<File> get tempFile async {
    final dir = await getTemporaryDirectory();
    final file = File(dir.path + Platform.pathSeparator + _tempFile);
    if (!(await file.exists())) await file.create();
    return file;
  }

  Future<void> _prepare() async {
    final publicKeys = <String>[];
    if (widget.pgpKey?.key != null) {
      publicKeys.add(widget.pgpKey?.key ?? '');
    }
    if (widget.userPublicKey?.key != null) {
      publicKeys.add(widget.userPublicKey?.key ?? '');
    }
    String? privateKey;
    if (widget.useSign == true) {
      privateKey = widget.userPrivateKey?.key;
    }
    legacyPgpApi = LegacyPgpApi(
      pgp: widget.pgp,
      temp: await tempFile,
      publicKeys: publicKeys,
      privateKey: privateKey,
    );
  }

  @override
  void dispose() {
    legacyPgpApi.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final s = context.l10n;
    final size = MediaQuery.of(context).size;
    final actions = <Widget>[
      if (link != null)
        TextButton(
          child: Text(widget.pgpKey != null ? s.send_encrypted : s.send),
          onPressed: sendProgress
              ? null
              : () {
                  sendEmail();
                },
        ),
      TextButton(
        child: Text(s.cancel),
        onPressed: () {
          Navigator.pop(context);
        },
      )
    ];
    final title = Text(s.btn_encrypted_shareable_link);
    final content = SizedBox(
      height: min(size.height / 2, 350),
      width: min(size.width - 40, 300),
      child: Stack(
        children: <Widget>[
          ListView(
            padding: EdgeInsets.all(0),
            children: <Widget>[
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

    return AlertDialog(
      title: title,
      content: content,
      actions: actions,
    );
  }

  sendEmail() async {
    final s = context.l10n;
    sendProgress = true;
    setState(() {});
    toastKey.currentState?.show(s.sending);
    final recipient = widget.recipient?.fullName ??
        widget.recipient?.email ??
        widget.pgpKey?.email;

    var template = MailTemplate.getTemplate(
      widget.useEncrypt,
      widget.useKey,
      widget.file.localFile.name,
      link ?? '',
      widget.pgpKey != null ? password : null,
      recipient ?? '',
      AppStore.authState.userEmail ?? '',
    );

    if (widget.pgpKey != null) {
      final encrypt = await legacyPgpApi.encryptBytes(
        template.body,
        widget.privateKeyPassword,
      );

      template.body = encrypt;
    }

    widget.filesState
        .sendViaEmail(
            template, widget.recipient?.email ?? widget.pgpKey?.email ?? '')
        .then(
      (_) {
        toastKey.currentState?.show(s.sending_complete);
      },
      onError: (e) {
        toastKey.currentState?.show(s.failed);
      },
    ).whenComplete(() {
      sendProgress = false;
      setState(() {});
    });
  }

  List<Widget> progressLabel() {
    final s = context.l10n;
    final theme = Theme.of(context);
    String? recipient = widget.recipient?.fullName;
    if (recipient?.isNotEmpty != true) {
      recipient = widget.recipient?.email;
    }
    if (recipient?.isNotEmpty != true) {
      recipient = widget.pgpKey?.email;
    }
    if (error != null) {
      return [
        SizedBox(height: 10),
        Text(error ?? ''),
        SizedBox(height: 10),
        Center(
          child: AMButton(
            onPressed: () {
              error = null;
              share(context);
            },
            child: Text(s.try_again),
          ),
        )
      ];
    }
    if (link == null) {
      return [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
            child: CircularProgressIndicator(),
          ),
        ),
      ];
    }
    return [
      ClipboardLabel(link ?? '', s.encrypted_file_link, () {
        toastKey.currentState?.show(s.link_coppied_to_clipboard);
      }),
      SizedBox(
        height: 10,
      ),
      if (!widget.useKey)
        ClipboardLabel(password, s.encrypted_file_password, () {
          toastKey.currentState?.show(s.link_coppied_to_clipboard);
        }),
      if (!widget.useKey) SizedBox(height: 10),
      Text(
        widget.useKey
            ? widget.useSign
                ? s.encrypted_sign_using_key(recipient ?? '')
                : s.encrypted_using_key(recipient ?? '')
            : widget.pgpKey != null
                ? s.encrypted_using_password
                : s.copy_encrypted_password,
        style: theme.textTheme.caption,
      )
    ];
  }

  static const _tempFile = "temp.pgp";
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
