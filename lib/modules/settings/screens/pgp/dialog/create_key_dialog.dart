import 'package:aurora_ui_kit/aurora_ui_kit.dart';
import 'package:aurorafiles/l10n/l10n.dart';
import 'package:aurorafiles/modules/app_store.dart';
import 'package:aurorafiles/modules/settings/repository/pgp_key_util.dart';
import 'package:aurorafiles/modules/settings/screens/pgp/dialog/confirm_delete_key_widget.dart';
import 'package:aurorafiles/utils/input_validation.dart';
import 'package:crypto_stream/algorithm/pgp.dart';
import 'package:flutter/material.dart';

class CreateKeyDialog extends StatefulWidget {
  final PgpKeyUtil pgpKeyUtil;

  const CreateKeyDialog(this.pgpKeyUtil, {super.key});

  @override
  _CreateKeyDialogState createState() => _CreateKeyDialogState();
}

class _CreateKeyDialogState extends State<CreateKeyDialog> {
  final _emailController =
      TextEditingController(text: AppStore.authState.userEmail);
  final _lengthController = TextEditingController(text: lengths[1].toString());
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _obscure = true;
  static const lengths = [1024, 2048, 3072, 4096, 8192];
  var length = lengths[1];

  @override
  void dispose() {
    _emailController.dispose();
    _lengthController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final s = context.l10n;
    final title = Text(s.generate_keys);
    return AMDialog(
      title: title,
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  TextFormField(
                    enabled: false,
                    decoration: InputDecoration(
                      labelText: s.email,
                      alignLabelWithHint: true,
                    ),
                    validator: (v) =>
                        validateInput(v ?? '', [ValidationTypes.email]),
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: s.password,
                      alignLabelWithHint: true,
                      suffix: GestureDetector(
                        child: Icon(
                          _obscure ? Icons.visibility : Icons.visibility_off,
                        ),
                        onTap: () {
                          _obscure = !_obscure;
                          setState(() {});
                        },
                      ),
                    ),
                    validator: (v) =>
                        validateInput(v ?? '', [ValidationTypes.empty]),
                    controller: _passwordController,
                    obscureText: _obscure,
                  ),
                  DropdownButtonFormField<int>(
                    hint: Text(length.toString()),
                    decoration: InputDecoration(
                      labelText: s.length,
                      alignLabelWithHint: true,
                    ),
                    value: length,
                    items: lengths.map((value) {
                      return DropdownMenuItem<int>(
                        value: value,
                        child: Text(
                          value.toString(),
                        ),
                      );
                    }).toList(),
                    onChanged: (v) {
                      if (v != null) {
                        length = v;
                        setState(() {});
                      }
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(
          onPressed: _pop,
          child: Text(s.close),
        ),
        TextButton(
          onPressed: () {
            if (_formKey.currentState?.validate() == true) {
              _generate();
            }
          },
          child: Text(s.generate),
        ),
      ],
    );
  }

  // String? _validateInput() {
  //   _error = null;
  //   _error = validateInput(_emailController.text, [ValidationTypes.email]);
  //   if (_error != null) return _error;
  //   _error = _validatePassword(_passwordController.text);
  //   return _error;
  // }

  // String? _validatePassword(String text) {
  //   final s = context.l10n;
  //   if (text.isEmpty) {
  //     return s.password_is_empty;
  //   }
  //   return null;
  // }

  _generate() async {
    final s = context.l10n;
    final email = _emailController.text;
    final password = _passwordController.text;
    final hasKey = await widget.pgpKeyUtil.checkHasKey(_emailController.text);
    if (hasKey) {
      final result = await AMDialog.show(
        context: context,
        builder: (_) => ConfirmDeleteKeyWidget(s.already_have_key),
      );
      if (result != true) {
        return;
      }
      await widget.pgpKeyUtil.deleteByEmail([email]);
    }

    final future = widget.pgpKeyUtil.createKeys(length, email, password);
    if (!mounted) return;
    Navigator.pop(context, CreateKeyResult(email, length, future, hasKey, ""));
  }

  _pop() {
    Navigator.pop(context);
  }
}

class CreateKeyResult {
  final String email;
  final String name;
  final int length;
  final Future<KeyPair> keyBuilder;
  final bool needUpdate;

  CreateKeyResult(
      this.email, this.length, this.keyBuilder, this.needUpdate, this.name);
}
