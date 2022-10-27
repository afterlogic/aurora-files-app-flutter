import 'package:aurorafiles/l10n/l10n.dart';
import 'package:aurorafiles/modules/settings/repository/encryption_local_storage.dart';
import 'package:aurorafiles/modules/settings/repository/pgp_key_util.dart';
import 'package:flutter/material.dart';

class KeyRequestDialog extends StatefulWidget {
  final bool? forSign;

  const KeyRequestDialog(this.forSign, {super.key});

  @override
  State<StatefulWidget> createState() {
    return _KeyRequestDialogState();
  }

  static Future<String?> request(BuildContext context, {bool? forSign}) async {
    if (EncryptionLocalStorage.memoryPassword != null) {
      return EncryptionLocalStorage.memoryPassword;
    }
    final password = await showDialog(
      context: context,
      builder: (context) {
        return KeyRequestDialog(forSign);
      },
    );
    if (password != null) {
      if (await EncryptionLocalStorage.instance.getStorePasswordStorage()) {
        EncryptionLocalStorage.memoryPassword = password;
      }
    }
    return password;
  }
}

class InvalidKeyPassword extends Error {
  @override
  String toString() {
    return "Invalid password";
  }
}

class _KeyRequestDialogState extends State<KeyRequestDialog> {
  final passCtrl = TextEditingController();
  final formKey = GlobalKey<FormState>();
  bool obscure = true;
  String? error;

  bool isProgress = false;

  @override
  Widget build(BuildContext context) {
    final s = context.l10n;
    return AlertDialog(
      title: Text(s.label_encryption_password_for_pgp_key),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Form(
            key: formKey,
            child: TextFormField(
              enabled: !isProgress,
              validator: (v) {
                if (v?.isNotEmpty != true) {
                  return s.password_is_empty;
                }
                if (error != null) {
                  final _error = error;
                  error = null;
                  return _error;
                }
                return null;
              },
              obscureText: obscure,
              decoration: InputDecoration(
                labelText: s.password,
                helperText: '',
                suffixIcon: Padding(
                  padding: const EdgeInsets.only(top: 11),
                  child: IconButton(
                    icon: Icon(
                      obscure ? Icons.visibility : Icons.visibility_off,
                    ),
                    onPressed: () {
                      setState(() => obscure = !obscure);
                    },
                  ),
                ),
              ),
              controller: passCtrl,
            ),
          ),
        ],
      ),
      actions: <Widget>[
        TextButton(
          onPressed: isProgress
              ? null
              : () {
                  if (formKey.currentState?.validate() ?? false) {
                    _check();
                  }
                },
          child: isProgress ? const CircularProgressIndicator() : Text(s.oK),
        )
      ],
    );
  }

  _check() async {
    setState(() {
      isProgress = true;
    });
    if (!await PgpKeyUtil.instance.checkPrivateKey(
      passCtrl.text,
      (await PgpKeyUtil.instance.userPrivateKey())?.key ?? '',
    )) {
      error = "Invalid password";
      formKey.currentState?.validate();
      isProgress = false;
      setState(() {});
      return;
    }
    Navigator.pop(context, passCtrl.text);
  }
}
