import 'dart:io';

import 'package:aurorafiles/database/app_database.dart';
import 'package:aurorafiles/database/pgp_key/pgp_key.dart';
import 'package:aurorafiles/database/pgp_key/pgp_key_dao.dart';
import 'package:aurorafiles/di/di.dart';
import 'package:aurorafiles/models/recipient.dart';
import 'package:aurorafiles/modules/files/state/file_viewer_state.dart';
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
  final PgpKeyDao _pgpKeyDao = DI.get();
  bool hasError = false;
  List<RecipientWithKey> recipients = [];
  Map<String, LocalPgpKey> keys;

  loadRecipients() {
    if (mounted) setState(() {});
    hasError = false;
    recipients = null;
    widget.fileViewerState.getRecipient().then(
      (v) async {
        recipients = [];
        await loadKeys();
        for (Recipient recipient in v) {
          final key = keys.remove(recipient.email);
          recipients.add(RecipientWithKey(recipient, key));
        }
        keys.forEach((key, value) {
          recipients.add(RecipientWithKey(null, value));
        });

        setState(() {});
      },
      onError: (e) {
        hasError = true;
        setState(() {});
      },
    );
  }

  loadKeys() async {
    final localKeys = await _pgpKeyDao.getKeys();
    keys = Map.fromEntries(
      localKeys.map(
        (item) => MapEntry(item.email, item),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    loadRecipients();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;
    final title = Text("Secure sharing");
    final content = SizedBox(
      height: size.height - 40,
      width: size.width - 40,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: body(theme),
      ),
    );
    final actions = <Widget>[
      FlatButton(
        child: Text("Cancel"),
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

  List<Widget> body(ThemeData theme) {
    if (recipients != null) {
      if (recipients.isEmpty) {
        return [
          Expanded(
            child: Center(
              child: Text("Not have recipiens"),
            ),
          )
        ];
      }

      return [
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
              );
            },
            itemCount: recipients.length,
          ),
        )
      ];
    }
    if (hasError) {
      return [
        Expanded(
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                  "Cant load recipients:",
                  style: theme.textTheme.title,
                ),
                FlatButton(
                  child: Text("Try again"),
                  onPressed: loadRecipients,
                ),
              ],
            ),
          ),
        ),
      ];
    }
    return [
      Expanded(
        child: Center(
          child: CircularProgressIndicator(),
        ),
      ),
    ];
  }
}

class RecipientWithKey {
  final Recipient recipient;
  final LocalPgpKey pgpKey;

  RecipientWithKey(this.recipient, this.pgpKey);
}

class RecipientWidget extends StatelessWidget {
  final RecipientWithKey recipient;

  RecipientWidget(this.recipient);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    var name = recipient.recipient?.fullName;
    final hasName = !(name?.isNotEmpty != true);
    if (!hasName) {
      name = "No name";
    }
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        Navigator.pop(context, recipient);
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
                      name,
                      maxLines: 1,
                      style: hasName
                          ? theme.textTheme.body2
                          : theme.textTheme.body2.apply(color: Colors.grey),
                    ),
                    Text(
                      recipient.recipient?.email ?? recipient.pgpKey.email,
                      maxLines: 1,
                      style: theme.textTheme.caption,
                    ),
                  ],
                ),
              ),
              if (recipient.pgpKey != null) Icon(Icons.vpn_key)
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
