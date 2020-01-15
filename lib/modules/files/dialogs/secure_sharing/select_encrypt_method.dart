import 'dart:io';
import 'dart:math';

import 'package:aurorafiles/database/app_database.dart';
import 'package:aurorafiles/generated/i18n.dart';
import 'package:aurorafiles/models/recipient.dart';
import 'package:aurorafiles/modules/files/components/sign_check_box.dart';
import 'package:aurorafiles/modules/files/dialogs/secure_sharing/select_recipient.dart';
import 'package:aurorafiles/modules/settings/repository/pgp_key_util.dart';
import 'package:aurorafiles/shared_ui/toast_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SelectEncryptMethod extends StatefulWidget {
  final LocalPgpKey userPgpKey;
  final Recipient recipient;
  final LocalPgpKey pgpKey;
  final PgpKeyUtil pgpUtil;

  const SelectEncryptMethod(
      this.userPgpKey, this.recipient, this.pgpKey, this.pgpUtil);

  @override
  _SelectEncryptMethodState createState() => _SelectEncryptMethodState();
}

class _SelectEncryptMethodState extends State<SelectEncryptMethod> {
  final signKey = GlobalKey<SignCheckBoxState>();
  final toastKey = GlobalKey<ToastWidgetState>();
  bool useKey;
  bool useSign;
  S s;

  @override
  void initState() {
    useKey = widget.pgpKey != null;
    useSign = useKey && widget.userPgpKey != null;
    super.initState();
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
      child: Stack(
        children: <Widget>[
          ListView(
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
                height: 20,
              ),
              Text(
                s.encryption_type,
                style: theme.textTheme.subtitle,
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
                key: signKey,
                checked: useSign,
                enable: widget.pgpKey != null,
                label: !useKey
                    ? s.password_sign
                    : widget.pgpKey == null
                        ? s.sign_with_not_key(s.data)
                        : useSign
                            ? s.data_signed(s.data)
                            : s.data_not_signed_but_enc(s.data),
                onCheck: (bool check) {
                  useSign = check;
                  setState(() {});
                },
              ),
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
      FlatButton(
        child: Text(s.encrypt),
        onPressed: () {
          checkSign();
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

  checkSign() async {
    String password;
    if (useSign && widget.userPgpKey != null) {
      password = signKey.currentState.password;
      if (password.isEmpty) {
        toastKey.currentState.show(s.password_is_empty);
        return;
      }
      final isValidPassword =
          await widget.pgpUtil.checkPrivateKey(password, widget.userPgpKey.key);
      if (!isValidPassword) {
        toastKey.currentState.show(s.invalid_password);
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
    final s = S.of(context);
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
                style: theme.textTheme.body1,
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
              style: theme.textTheme.body1,
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
    return Platform.isIOS
        ? Padding(
            padding: EdgeInsets.all(10),
            child: Icon(isCheck
                ? Icons.radio_button_checked
                : Icons.radio_button_unchecked),
          )
        : Radio(
            value: false,
            groupValue: !isCheck,
          );
  }
}

class SelectEncryptMethodResult {
  final bool useKey;
  final bool useSign;
  final String password;

  SelectEncryptMethodResult(this.useKey, this.useSign, this.password);
}
