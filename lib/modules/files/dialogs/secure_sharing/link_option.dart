import 'dart:io';

import 'package:aurorafiles/generated/i18n.dart';
import 'package:aurorafiles/modules/files/repository/files_local_storage.dart';
import 'package:aurorafiles/modules/files/state/file_viewer_state.dart';
import 'package:aurorafiles/utils/pgp_key_util.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LinkOptionWidget extends StatefulWidget {
  final PreparedForShare file;
  final FileViewerState fileViewerState;

  LinkOptionWidget(this.file, this.fileViewerState);

  @override
  _LinkOptionWidgetState createState() => _LinkOptionWidgetState();
}

class _LinkOptionWidgetState extends State<LinkOptionWidget> {
  bool encryptLink = false;
  bool progress = false;
  String error;

  createLink() {
    progress = true;
    error = null;
    setState(() {});
    if (encryptLink) {
      widget.file.localFile = widget.file.localFile
          .copyWith(linkPassword: PgpUtil.createSymmetricKey());

      widget.fileViewerState.createSecureLink(
          file: widget.file.file,
          onSuccess: (link) {
            widget.file.localFile = widget.file.localFile
                .copyWith(linkUrl: link.link, published: true);
            Navigator.pop(context, true);
          },
          onError: onError,
          extend: "",
          password: widget.file.localFile.linkPassword);
    } else {
      widget.fileViewerState.createPublicLink(
        file: widget.file.file,
        onSuccess: (link) {
          widget.file.localFile =
              widget.file.localFile.copyWith(linkUrl: link, published: true);
          Navigator.pop(context, true);
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

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);

    final title = Text(s.create_link);
    final content = Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        progress
            ? CircularProgressIndicator()
            : GestureDetector(
                onTap: () {
                  encryptLink = !encryptLink;
                  setState(() {});
                },
                child: Row(
                  children: [
                    Checkbox(
                      value: encryptLink,
                      onChanged: (bool value) {
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
              ),
        if (error != null) Text(error),
      ],
    );

    final actions = <Widget>[
      FlatButton(
        child: Text(encryptLink ? s.create_encrypt_link : s.create_link),
        onPressed: () {
          createLink();
        },
      ),
      FlatButton(
        child: Text(s.cancel),
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
