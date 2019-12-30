import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:aurorafiles/di/di.dart';
import 'package:aurorafiles/generated/i18n.dart';
import 'package:aurorafiles/modules/app_store.dart';
import 'package:aurorafiles/modules/files/dialogs/secure_sharing/select_recipient.dart';
import 'package:aurorafiles/modules/files/dialogs/secure_sharing/share_progress.dart';
import 'package:aurorafiles/modules/files/repository/files_local_storage.dart';
import 'package:aurorafiles/modules/files/state/file_viewer_state.dart';
import 'package:aurorafiles/modules/files/state/files_state.dart';
import 'package:aurorafiles/shared_ui/app_button.dart';
import 'package:aurorafiles/shared_ui/toast_widget.dart';
import 'package:aurorafiles/utils/mail_template.dart';
import 'package:aurorafiles/utils/offline_utils.dart';
import 'package:aurorafiles/utils/pgp_key_util.dart';
import 'package:crypto_plugin/crypto_plugin.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:url_launcher/url_launcher.dart';

class ShareLink extends StatefulWidget {
  final bool usePassword;
  final PreparedForShare file;
  final RecipientWithKey selectRecipientResult;
  final FilesState filesState;
  final FileViewerState fileViewerState;

  ShareLink(
    this.usePassword,
    this.file,
    this.selectRecipientResult,
    this.filesState,
    this.fileViewerState,
  );

  @override
  _ShareLinkState createState() => _ShareLinkState();
}

class _ShareLinkState extends State<ShareLink> {
  Pgp pgp = DI.get();
  S s;
  bool progress = false;
  bool sendProgress = false;
  String error;
  final toastKey = GlobalKey<ToastWidgetState>();

  @override
  void initState() {
    super.initState();
    if (!widget.file.localFile.published) {
      _createLink();
    }
  }

  _createLink() {
    progress = true;
    error = null;
    if (mounted) setState(() {});
    if (widget.usePassword) {
      widget.file.localFile = widget.file.localFile
          .copyWith(linkPassword: PgpUtil.createSymmetricKey());

      widget.fileViewerState.createSecureLink(
          onSuccess: (link) {
            widget.file.localFile = widget.file.localFile
                .copyWith(linkUrl: link.link, published: true);
            progress = false;
            setState(() {});
          },
          onError: onError,
          extend: "",
          password: widget.file.localFile.linkPassword);
    } else {
      widget.fileViewerState.createPublicLink(
        onSuccess: (link) {
          widget.file.localFile =
              widget.file.localFile.copyWith(linkUrl: link, published: true);
          progress = false;
          setState(() {});
        },
        onError: onError,
        extend: "",
      );
    }
  }

  onError(e) {
    progress = false;
    error = e.toString();
    setState(() {});
  }

  void _deleteLink() async {
    widget.file.localFile = widget.file.localFile
        .copyWith(linkPassword: "", linkUrl: "", published: false);

    widget.filesState.onDeletePublicLink(
      path: widget.file.localFile.path,
      name: widget.file.localFile.name,
      onSuccess: () async {},
      onError: (String err) {},
    );
    await widget.filesState
        .updateFile(getCompanionFromLocalFile(widget.file.localFile));
    Navigator.pop(context);
  }

  void _sendTo() async {
    sendProgress = true;
    toastKey.currentState.show(s.sending);
    setState(() {});
    final recipient = widget.selectRecipientResult.recipient?.fullName ??
        widget.selectRecipientResult.recipient?.email ??
        widget.selectRecipientResult.pgpKey?.email;

    var template = MailTemplate.getTemplate(
      false,
      false,
      widget.file.localFile.name,
      widget.file.localFile.linkUrl,
      widget.selectRecipientResult.pgpKey != null
          ? widget.file.localFile.linkPassword
          : null,
      recipient,
      AppStore.authState.userEmail,
    );

    if (widget.selectRecipientResult.pgpKey != null) {
      pgp.setTempFile(
          File((await getTemporaryDirectory()).path + "/temp" + ".temp"));
      pgp.setPublicKey(widget.selectRecipientResult.pgpKey.key);

      final encrypt =
          await pgp.encryptBytes(Uint8List.fromList(template.body.codeUnits));

      template.body = String.fromCharCodes(encrypt);
    }

    widget.filesState
        .sendViaEmail(
            template,
            widget.selectRecipientResult.recipient?.email ??
                widget.selectRecipientResult.pgpKey?.email)
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

  @override
  Widget build(BuildContext context) {
    s = S.of(context);
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;
    final title = Text(s.secure_sharing);
    final content = SizedBox(
        height: min(size.height / 2, 350),
        width: min(size.width - 40, 300),
        child: progress
            ? Center(
                child: CircularProgressIndicator(),
              )
            : error != null
                ? Center(
                    child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(error),
                      AppButton(
                        text: s.try_again,
                        onPressed: _createLink,
                      )
                    ],
                  ))
                : Stack(
                    children: [
                      ListView(
                        children: [
                          ClipboardLabel(
                              widget.file.localFile.linkUrl, s.public_link, () {
                            toastKey.currentState
                                .show(s.link_coppied_to_clipboard);
                          }),
                          if (widget.file.localFile.linkPassword?.isNotEmpty ==
                              true)
                            ClipboardLabel(
                                widget.file.localFile.linkPassword, s.password,
                                () {
                              toastKey.currentState
                                  .show(s.link_coppied_to_clipboard);
                            }),
                          if (widget.selectRecipientResult != null) ...[
                            Text(s.recipient),
                            SizedBox(height: 10),
                            RecipientWidget(
                              widget.selectRecipientResult,
                              (_) {
                                Navigator.pop(context, true);
                              },
                            ),
                            SizedBox(height: 10),
                            Text(
                              widget.file.localFile.linkPassword?.isNotEmpty ==
                                      true
                                  ? widget.selectRecipientResult.pgpKey != null
                                      ? s.encrypted_mail_using_key
                                      : s.copy_password
                                  : s.send_email,
                              style: theme.textTheme.caption,
                            )
                          ],
                        ],
                      ),
                      Align(
                        alignment: Alignment(0, 1),
                        child: ToastWidget(
                          key: toastKey,
                        ),
                      ),
                    ],
                  ));
    final actions = <Widget>[
      widget.selectRecipientResult == null
          ? FlatButton(
              child: Text(s.send_to),
              onPressed: () {
                Navigator.pop(context, true);
              },
            )
          : FlatButton(
              child: Text(widget.selectRecipientResult.pgpKey != null
                  ? s.send_encrypted
                  : s.send),
              onPressed: sendProgress
                  ? null
                  : () {
                      _sendTo();
                    },
            ),
      FlatButton(
        child: Text(s.remove_link),
        onPressed: () {
          _deleteLink();
        },
      ),
      FlatButton(
        child: Text(widget.selectRecipientResult != null ? s.cancel : s.close),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
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
