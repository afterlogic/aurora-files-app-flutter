import 'dart:io';

import 'package:domain/api/cache/database/pgp_key_cache_api.dart';
import 'package:domain/model/bd/local_file.dart';
import 'package:aurorafiles/di/di.dart';
import 'package:aurorafiles/models/recipient.dart';
import 'package:aurorafiles/modules/files/state/file_viewer_state.dart';
import 'package:domain/model/bd/pgp_key.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SelectRecipient extends StatefulWidget {
  final FileViewerState fileViewerState;
  final LocalFile file;

  SelectRecipient(this.file, this.fileViewerState);

  @override
  _SelectRecipientState createState() => _SelectRecipientState();
}

class _SelectRecipientState extends State<SelectRecipient> {
  final PgpKeyCacheApi _pgpKeyDao = DI.get();
  bool hasError = false;
  List<Recipient> recipients;
  Map<String, PgpKey> keys;

  loadRecipients() {
    hasError = false;
    widget.fileViewerState.getRecipient().then(
      (v) async {
        recipients = v;
        final localKeys = await _pgpKeyDao.getAll();
        keys = Map.fromEntries(
          localKeys.map(
            (item) => MapEntry(item.email, item),
          ),
        );

        setState(() {});
      },
      onError: (e) {
        hasError = true;
        setState(() {});
      },
    );
  }

  @override
  void initState() {
    loadRecipients();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;
    final content = SizedBox(
      height: size.height - 40,
      width: size.width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 10,
            ),
            child: Text("Secure sharing", style: theme.textTheme.title),
          ),
          SizedBox(
            height: 20,
          ),
          ...body(theme),
        ],
      ),
    );
    return Platform.isIOS
        ? CupertinoAlertDialog(
            content: content,
            actions: <Widget>[
              CupertinoButton(
                child: Text("Cancel"),
                onPressed: () {
                  Navigator.pop(context);
                },
              )
            ],
          )
        : AlertDialog(content: content);
  }

  List<Widget> body(ThemeData theme) {
    return recipients != null
        ? [
            Text(
              "Select recipient:",
              style: theme.textTheme.subtitle,
            ),
            SizedBox(
              height: 10,
            ),
            Expanded(
              child: ListView.builder(
                itemBuilder: (_, i) {
                  final recipient = recipients[i];
                  return RecipientWidget(
                    recipient,
                    keys[recipient.email],
                  );
                },
                itemCount: recipients.length,
              ),
            )
          ]
        : hasError
            ? [
                Text(
                  "Cant load recipients:",
                  style: theme.textTheme.title,
                ),
                Expanded(
                  child: Center(
                    child: FlatButton(
                      child: Text("Try again"),
                      onPressed: loadRecipients,
                    ),
                  ),
                ),
              ]
            : [
                Center(
                  child: CircularProgressIndicator(),
                ),
              ];
  }
}

class SelectRecipientResult {
  final Recipient recipient;
  final PgpKey pgpKey;

  SelectRecipientResult(this.recipient, this.pgpKey);
}

class RecipientWidget extends StatelessWidget {
  final Recipient recipient;
  final PgpKey pgpKey;

  RecipientWidget(this.recipient, this.pgpKey);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        Navigator.pop(context, SelectRecipientResult(recipient, pgpKey));
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Divider(
            color: Colors.transparent,
          ),
          Flex(
            direction: Axis.horizontal,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text(
                      recipient.fullName,
                      maxLines: 1,
                      style: theme.textTheme.body2,
                    ),
                    Text(
                      recipient.email,
                      maxLines: 1,
                      style: theme.textTheme.caption,
                    ),
                  ],
                ),
              ),
              if (pgpKey != null) Icon(Icons.vpn_key)
            ],
          ),
          Divider(
            color: Colors.grey,
          )
        ],
      ),
    );
  }
}
