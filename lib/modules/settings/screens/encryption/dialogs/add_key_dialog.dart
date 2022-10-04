import 'package:aurora_ui_kit/aurora_ui_kit.dart';
import 'package:aurorafiles/l10n/l10n.dart';
import 'package:aurorafiles/modules/app_store.dart';
import 'package:aurorafiles/modules/settings/state/settings_state.dart';
import 'package:aurorafiles/utils/input_validation.dart';
import 'package:flutter/material.dart';

class AddKeyDialog extends StatefulWidget {
  final SettingsState settingsState;
  final bool isImport;

  const AddKeyDialog({
    Key? key,
    this.isImport = false,
    required this.settingsState,
  }) : super(key: key);

  @override
  _AddKeyDialogState createState() => _AddKeyDialogState();
}

class _AddKeyDialogState extends State<AddKeyDialog> {
  final _keyCtrl = TextEditingController();
  final _nameCtrl = TextEditingController();
  final _addKeyFormKey = GlobalKey<FormState>();
  bool _isAdding = false;
  String errMsg = "";

  @override
  void initState() {
    super.initState();
    _nameCtrl.text = AppStore.authState.userEmail ?? '';
  }

  @override
  Widget build(BuildContext context) {
    final s = context.l10n;
    return AMDialog(
      title: Text(widget.isImport ? s.import_key : s.generate_key),
      content: _isAdding
          ? Row(
              children: <Widget>[
                CircularProgressIndicator(),
                SizedBox(width: 20.0),
                Text(s.add_key_progress)
              ],
            )
          : Form(
              key: _addKeyFormKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  TextFormField(
                    controller: _nameCtrl,
                    autofocus: true,
                    decoration: InputDecoration(
                      isDense: true,
                      icon: Icon(Icons.title),
                      hintText: s.key_name,
                      border: UnderlineInputBorder(),
                    ),
                    validator: (value) => validateInput(
                      value ?? '',
                      [ValidationTypes.empty, ValidationTypes.uniqueName],
                      widget.settingsState.encryptionKeys.keys.toList(),
                    ),
                  ),
                  if (widget.isImport) SizedBox(height: 8.0),
                  if (widget.isImport)
                    TextFormField(
                      controller: _keyCtrl,
                      decoration: InputDecoration(
                        isDense: true,
                        icon: Icon(Icons.vpn_key),
                        hintText: s.key_text,
                        border: UnderlineInputBorder(),
                      ),
                      validator: (value) => validateInput(
                        value ?? '',
                        [ValidationTypes.empty],
                      ),
                    ),
                ],
              ),
            ),
      actions: <Widget>[
        TextButton(
          child: Text(s.cancel),
          onPressed: () => Navigator.pop(context),
        ),
        TextButton(
            child: Text(widget.isImport ? s.import : s.generate),
            onPressed: _isAdding
                ? null
                : () async {
                    if (_addKeyFormKey.currentState?.validate() == false)
                      return;
                    errMsg = "";
                    setState(() => _isAdding = true);
                    await widget.settingsState.onAddKey(
                      name: _nameCtrl.text,
                      encryptionKey: widget.isImport ? _keyCtrl.text : null,
                      onError: (String err) {
                        errMsg = err;
                        setState(() => _isAdding = false);
                      },
                    );
                    await widget.settingsState.getUserEncryptionKeys();
                    Navigator.pop(context, true);
                  }),
      ],
    );
  }
}
