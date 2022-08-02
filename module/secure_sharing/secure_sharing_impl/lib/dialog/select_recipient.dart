import 'dart:math';
import 'package:aurorafiles/modules/files/state/files_state.dart';
import 'package:aurorafiles/modules/settings/repository/pgp_key_api.dart';
import 'package:aurorafiles/database/app_database.dart';
import 'package:aurorafiles/database/pgp_key/pgp_key_dao.dart';
import 'package:aurorafiles/di/di.dart';
import 'package:aurorafiles/generated/s_of_context.dart';
import 'package:aurorafiles/models/recipient.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SelectRecipient extends StatefulWidget {
  final FilesState filesState;
  final String title;

  SelectRecipient(this.filesState, this.title);

  @override
  _SelectRecipientState createState() => _SelectRecipientState();
}

class _SelectRecipientState extends State<SelectRecipient> {
  final PgpKeyDao _pgpKeyDao = DI.get();
  final pgpApi = PgpKeyApi();
  final List<RecipientWithKey> recipients = [];

  late S s;

  Map<String, LocalPgpKey> keys = {};
  bool hasError = false;
  bool inProgress = false;

  @override
  void initState() {
    super.initState();
    s = Str.of(context);
    _loadRecipients();
  }

  void _loadRecipients() {
    hasError = false;
    _setProgress(true);
    recipients.clear();
    widget.filesState.getRecipient().then(
      (result) async {
        await _loadKeys();
        final filterRecipients =
            result.where((item) => item.email?.isNotEmpty == true);
        for (Recipient recipient in filterRecipients) {
          final key = keys.remove(recipient.email);
          recipients.add(RecipientWithKey(recipient, key));
        }
        keys.forEach((key, value) {
          recipients.add(RecipientWithKey(null, value));
        });
        _setProgress(false);
      },
      onError: (e) {
        hasError = true;
        _setProgress(false);
      },
    );
  }

  Future<void> _loadKeys() async {
    final localKeys = await _pgpKeyDao.getPublicKeys();
    final userKey = await pgpApi.getKeyFromContacts();
    localKeys.addAll(userKey);
    keys = Map.fromEntries(
      localKeys.map(
        (item) => MapEntry(item.email, item),
      ),
    );
  }

  void _setProgress(bool value) {
    inProgress = value;
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {

    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;
    final title = Text(widget.title);
    final content = SizedBox(
      height: min(size.height / 2, 350),
      width: min(size.width - 40, 300),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: body(theme),
      ),
    );
    final actions = <Widget>[
      TextButton(
        child: Text(s.cancel),
        onPressed: () {
          Navigator.pop(context);
        },
      )
    ];

    return AlertDialog(
      title: title,
      content: content,
      actions: actions,
    );
  }

  List<Widget> body(ThemeData theme) {
    if (inProgress) {
      return [
        Expanded(
          child: Center(
            child: CircularProgressIndicator(),
          ),
        ),
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
                  style: theme.textTheme.headline6,
                ),
                TextButton(
                  child: Text(s.try_again),
                  onPressed: _loadRecipients,
                ),
              ],
            ),
          ),
        ),
      ];
    }
    if (recipients.isNotEmpty) {
      return [
        Text(
          s.select_recipient,
          style: theme.textTheme.subtitle2,
        ),
        SizedBox(height: 2),
        Expanded(
          child: ListView.separated(
            padding: EdgeInsets.all(0),
            itemBuilder: (_, i) {
              final recipient = recipients[i];
              return RecipientWidget(recipient, (recipient) {
                Navigator.pop(context, recipient);
              });
            },
            separatorBuilder: (_, __) => Divider(color: Colors.grey),
            itemCount: recipients.length,
          ),
        )
      ];
    }

    return [
      Expanded(
        child: Center(
          child: Text(s.not_have_recipiens),
        ),
      )
    ];
  }
}

class RecipientWithKey {
  final Recipient? recipient;
  final LocalPgpKey? pgpKey;

  RecipientWithKey(this.recipient, this.pgpKey);
}

class RecipientWidget extends StatelessWidget {
  final RecipientWithKey recipient;
  final Function(RecipientWithKey)? onTap;

  RecipientWidget(this.recipient, [this.onTap]);

  @override
  Widget build(BuildContext context) {
    final s = Str.of(context);
    final theme = Theme.of(context);
    var name = recipient.recipient?.fullName;
    final hasName = !(name?.isNotEmpty != true);
    if (!hasName) {
      name = s.no_name;
    }
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        if (onTap != null) onTap!(recipient);
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
                  name ?? '',
                  maxLines: 1,
                  style: hasName
                      ? theme.textTheme.bodyText1
                      : theme.textTheme.bodyText1?.apply(color: Colors.grey),
                ),
                Text(
                  recipient.recipient?.email ?? recipient.pgpKey?.email ?? '',
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
