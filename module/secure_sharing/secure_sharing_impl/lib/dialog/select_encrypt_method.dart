import 'dart:math';

import 'package:aurorafiles/modules/files/dialogs/key_request_dialog.dart';
import 'package:aurorafiles/override_platform.dart';
import 'package:aurorafiles/database/app_database.dart';
import 'package:aurorafiles/generated/s_of_context.dart';
import 'package:aurorafiles/models/recipient.dart';
import 'package:aurorafiles/modules/files/components/sign_check_box.dart';
import 'package:aurorafiles/modules/settings/repository/pgp_key_util.dart';
import 'package:aurorafiles/shared_ui/toast_widget.dart';
import 'package:flutter/material.dart';

import 'select_recipient.dart';

class SelectEncryptMethod extends StatefulWidget {
  final LocalPgpKey? userPgpKey;
  final Recipient? recipient;
  final LocalPgpKey? pgpKey;
  final PgpKeyUtil pgpUtil;

  const SelectEncryptMethod(
      this.userPgpKey, this.recipient, this.pgpKey, this.pgpUtil);

  @override
  _SelectEncryptMethodState createState() => _SelectEncryptMethodState();
}

class _SelectEncryptMethodState extends State<SelectEncryptMethod> {
  final toastKey = GlobalKey<ToastWidgetState>();
  late bool useKey;
  late bool useSign;
  late S s;

  @override
  void initState() {
    super.initState();
    useKey = widget.pgpKey != null;
    useSign = useKey && widget.userPgpKey != null && widget.pgpKey != null;
    s = Str.of(context);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;
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
              Text(
                widget.pgpKey != null
                    ? s.has_PGP_public_key
                    : s.has_no_PGP_public_key,
                style: theme.textTheme.caption,
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                s.encryption_type,
                style: theme.textTheme.subtitle2,
              ),
              RadioEncryptMethod(widget.pgpKey != null, useKey, (v) {
                useKey = v;
                useSign = useKey && widget.userPgpKey != null;
                setState(() {});
              }),
              SizedBox(
                height: 10,
              ),
              Text(
                useKey ? s.key_will_be_used : s.password_will_be_used,
                style: theme.textTheme.caption,
              ),
              SignCheckBox(
                checked: useSign,
                enable: useKey &&
                    widget.userPgpKey != null &&
                    widget.pgpKey != null,
                onCheck: (bool check) {
                  useSign = check;
                  setState(() {});
                },
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                !useKey
                    ? s.password_sign
                    : widget.pgpKey == null
                        ? s.sign_data_with_not_key(s.data)
                        : useSign
                            ? s.data_signed
                            : s.data_not_signed(s.data),
                style: theme.textTheme.caption,
              )
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

    final actions = <Widget>[
      TextButton(
        child: Text(s.encrypt),
        onPressed: () {
          checkSign();
        },
      ),
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

  checkSign() async {
    String password = '';
    if (useSign && widget.userPgpKey != null) {
      try {
        password = await KeyRequestDialog.request(context) ?? '';
      } catch (e) {
        toastKey.currentState?.show(s.invalid_password);
        return;
      }
    }
    Navigator.pop(
      context,
      SelectEncryptMethodResult(
        useKey,
        useSign,
        password,
      ),
    );
  }
}

class RadioEncryptMethod extends StatelessWidget {
  final bool value;
  final bool hasKey;
  final Function(bool) onChanged;

  RadioEncryptMethod(this.hasKey, this.value, this.onChanged);

  @override
  Widget build(BuildContext context) {
    final s = Str.of(context);
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Divider(
          color: Colors.transparent,
        ),
        if (hasKey)
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: value
                ? null
                : () {
                    onChanged(true);
                  },
            child: Row(children: <Widget>[
              RadioAnalog(value),
              Text(
                s.key_based,
                style: theme.textTheme.bodyText2,
              ),
            ]),
          ),
        if (hasKey)
          Divider(
            color: Colors.grey,
          ),
        GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: !value
              ? null
              : () {
                  onChanged(false);
                },
          child: Row(children: <Widget>[
            RadioAnalog(!value),
            Text(
              s.password_based,
              style: theme.textTheme.bodyText2,
            ),
          ]),
        ),
        Divider(
          color: Colors.grey,
        ),
      ],
    );
  }
}

class RadioAnalog extends StatelessWidget {
  final bool isCheck;

  const RadioAnalog(this.isCheck);

  @override
  Widget build(BuildContext context) {
    return PlatformOverride.isIOS
        ? Padding(
            padding: EdgeInsets.all(10),
            child: Icon(isCheck
                ? Icons.radio_button_checked
                : Icons.radio_button_unchecked),
          )
        : Radio(
            value: false,
            groupValue: !isCheck,
            onChanged: null,
          );
  }
}

class SelectEncryptMethodResult {
  final bool useKey;
  final bool useSign;
  final String password;

  SelectEncryptMethodResult(this.useKey, this.useSign, this.password);
}
