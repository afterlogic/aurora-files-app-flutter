import 'dart:math';

import 'package:aurora_ui_kit/aurora_ui_kit.dart';
import 'package:aurorafiles/database/app_database.dart';
import 'package:aurorafiles/di/di.dart';
import 'package:aurorafiles/generated/s_of_context.dart';
import 'package:aurorafiles/modules/app_store.dart';
import 'package:aurorafiles/modules/files/components/sign_check_box.dart';
import 'package:aurorafiles/modules/files/dialogs/key_request_dialog.dart';
import 'package:aurorafiles/modules/files/repository/files_local_storage.dart';
import 'package:aurorafiles/modules/files/state/files_state.dart';
import 'package:aurorafiles/modules/settings/repository/pgp_key_util.dart';
import 'package:aurorafiles/override_platform.dart';
import 'package:aurorafiles/shared_ui/toast_widget.dart';
import 'package:aurorafiles/utils/case_util.dart';
import 'package:aurorafiles/utils/mail_template.dart';
import 'package:aurorafiles/utils/offline_utils.dart';
import 'package:aurorafiles/utils/pgp_key_util.dart';
import 'package:crypto_stream/algorithm/pgp.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'encrypted_share_link.dart';
import 'select_recipient.dart';

class ShareLink extends StatefulWidget {
  final LocalPgpKey userPrivateKey;
  final LocalPgpKey userPublicKey;
  final bool usePassword;
  final PreparedForShare file;
  final RecipientWithKey selectRecipientResult;
  final FilesState filesState;
  final PgpKeyUtil pgpKeyUtil;

  ShareLink(
    this.userPrivateKey,
    this.userPublicKey,
    this.usePassword,
    this.file,
    this.selectRecipientResult,
    this.filesState,
    this.pgpKeyUtil,
  );

  @override
  _ShareLinkState createState() => _ShareLinkState();
}

class _ShareLinkState extends State<ShareLink> {
  Pgp pgp = DI.get();
  S s;
  bool progress = false;
  bool sendProgress = false;
  bool useSign;
  String error;
  final toastKey = GlobalKey<ToastWidgetState>();
  final signKey = GlobalKey<SignCheckBoxState>();

  @override
  void initState() {
    useSign = widget.userPrivateKey != null &&
        widget.selectRecipientResult?.pgpKey != null;
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
      widget.file.localFile = widget.file.localFile.copyWith(
        linkPassword: PgpUtil.createSymmetricKey(),
      );

      widget.filesState.createSecureLink(
        file: widget.file.localFile,
        email: "",
        isKey: false,
        onSuccess: (link) {
          widget.file.localFile = widget.file.localFile.copyWith(
            linkUrl: link.link,
            published: true,
          );
          progress = false;
          setState(() {});
        },
        onError: onError,
        password: widget.file.localFile.linkPassword,
      );
    } else {
      widget.filesState.createPublicLink(
        file: widget.file.localFile,
        onSuccess: (link) {
          widget.file.localFile =
              widget.file.localFile.copyWith(linkUrl: link, published: true);
          progress = false;
          setState(() {});
        },
        onError: onError,
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

  Future<bool> checkSign(String password) async {
    if (useSign && widget.userPrivateKey != null) {
      if (password.isEmpty) {
        toastKey.currentState.show(s.password_is_empty);
        return false;
      }
      final isValidPassword = await widget.pgpKeyUtil
          .checkPrivateKey(password, widget.userPrivateKey.key);
      if (!isValidPassword) {
        toastKey.currentState.show(s.invalid_password);
        return false;
      }
    }
    return true;
  }

  void _sendTo() async {
    sendProgress = true;
    toastKey.currentState.show(s.sending);
    setState(() {});
    final password = useSign ? await KeyRequestDialog.request(context) : null;
    if (!await checkSign(password)) {
      sendProgress = false;
      setState(() {});
      return;
    }

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
      final encrypt = await pgp.bufferPlatformSink(
        template.body,
        pgp.encrypt(
          useSign ? widget.userPrivateKey.key : null,
          [widget.selectRecipientResult.pgpKey.key, widget.userPublicKey?.key]
              .where((item) => item != null)
              .toList(),
          password,
        ),
      );

      template.body = encrypt;
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
    s = Str.of(context);
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;
    final title = Text(s.btn_shareable_link);

    final actions = <Widget>[
      widget.selectRecipientResult == null
          ? TextButton(
              child: Text(s.send_to),
              onPressed: () {
                Navigator.pop(context, true);
              },
            )
          : TextButton(
              child: Text(widget.selectRecipientResult?.pgpKey != null
                  ? s.send_encrypted
                  : s.send),
              onPressed: sendProgress
                  ? null
                  : () {
                      _sendTo();
                    },
            ),
      TextButton(
        child: Text(s.remove_link),
        onPressed: () {
          _deleteLink();
        },
      ),
      TextButton(
        child: Text(widget.selectRecipientResult != null ? s.cancel : s.close),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
    ];

    final content = SizedBox(
        height: PlatformOverride.isIOS ? size.height / 2 : size.height / 2,
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
                      AMButton(
                        child: Text(s.try_again),
                        onPressed: _createLink,
                      )
                    ],
                  ))
                : Stack(
                    children: [
                      contentWrap(
                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ClipboardLabel(widget.file.localFile.linkUrl,
                                    s.public_link, () {
                                  toastKey.currentState
                                      .show(s.link_coppied_to_clipboard);
                                }),
                                if (widget.file.localFile.linkPassword
                                        ?.isNotEmpty ==
                                    true)
                                  ClipboardLabel(
                                      widget.file.localFile.linkPassword,
                                      s.password, () {
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
                                  Divider(color: Colors.grey),
                                  if (widget.selectRecipientResult.pgpKey !=
                                      null)
                                    SignCheckBox(
                                      key: signKey,
                                      checked: useSign,
                                      enable: widget.userPrivateKey != null &&
                                          widget.selectRecipientResult
                                                  ?.pgpKey !=
                                              null,
                                      onCheck: (v) {
                                        useSign = v;
                                        setState(() {});
                                      },
                                    ),
                                  SizedBox(height: 10),
                                  Text(
                                    widget.selectRecipientResult.pgpKey == null
                                        ? widget.usePassword
                                            ? s.copy_password
                                            : s.send_email
                                        : widget.userPrivateKey == null
                                            ? s.sign_mail_with_not_key(
                                                s.email.firstCharTo(false))
                                            : useSign
                                                ? s.email_signed
                                                : s.email_not_signed,
                                    style: theme.textTheme.caption,
                                  ),
                                  SizedBox(height: 10),
                                ],
                              ],
                            ),
                            if (widget.selectRecipientResult?.pgpKey != null)
                              Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: actions,
                              )
                          ],
                        ),
                      ),
                      Align(
                        alignment: Alignment(0, 0.7),
                        child: ToastWidget(
                          key: toastKey,
                        ),
                      ),
                    ],
                  ));

    return AlertDialog(
      title: title,
      content: content,
      actions: widget.selectRecipientResult?.pgpKey != null ? null : actions,
    );
  }

  Widget contentWrap(Widget content) {
    if (widget.selectRecipientResult?.pgpKey != null) {
      return SingleChildScrollView(
        padding: EdgeInsets.all(0),
        child: content,
      );
    } else {
      return content;
    }
  }
}
