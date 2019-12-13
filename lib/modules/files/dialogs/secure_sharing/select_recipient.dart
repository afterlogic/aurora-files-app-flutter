import 'dart:io';
import 'dart:math';

import 'package:aurorafiles/database/app_database.dart';
import 'package:aurorafiles/database/pgp_key/pgp_key_dao.dart';
import 'package:aurorafiles/di/di.dart';
import 'package:aurorafiles/generated/i18n.dart';
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
  S s;
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
    s = S.of(context);
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;
    final title = Padding(
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: Text(s.secure_sharing),
    );
    final content = SizedBox(
      height: min(size.height / 2, 350),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: body(theme),
      ),
    );
    final actions = <Widget>[
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

  List<Widget> body(ThemeData theme) {
    if (recipients != null) {
      if (recipients.isEmpty) {
        return [
          Expanded(
            child: Center(
              child: Text(s.not_have_recipiens),
            ),
          )
        ];
      }

      return [
        if (Platform.isIOS)
          SizedBox(
            height: 10,
          ),
        Text(
          s.select_recipient,
          style: theme.textTheme.subtitle,
        ),
        SizedBox(
          height: 10,
        ),
        Expanded(
          child: ListView.separated(
            itemBuilder: (_, i) {
              final recipient = recipients[i];
              return RecipientWidget(
                recipient,
              );
            },
            separatorBuilder: (_, __) => Divider(color: Colors.grey),
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
                  s.cant_load_recipients,
                  style: theme.textTheme.title,
                ),
                FlatButton(
                  child: Text(s.try_again),
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
    final s=S.of(context);
    final theme = Theme.of(context);
    var name = recipient.recipient?.fullName;
    final hasName = !(name?.isNotEmpty != true);
    if (!hasName) {
      name = s.no_name;
    }
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        Navigator.pop(context, recipient);
      },
      child: Flex(
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
    );
  }
}
