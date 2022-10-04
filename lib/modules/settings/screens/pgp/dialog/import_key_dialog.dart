import 'package:aurorafiles/build_property.dart';
import 'package:aurorafiles/database/app_database.dart';
import 'package:aurorafiles/l10n/l10n.dart';
import 'package:aurorafiles/modules/settings/screens/pgp/component/key_item.dart';
import 'package:aurorafiles/modules/settings/screens/pgp/pgp_setting_presenter.dart';
import 'package:aurorafiles/override_platform.dart';
import 'package:aurorafiles/shared_ui/sized_dialog_content.dart';

import 'package:flutter/material.dart';

class ImportKeyDialog extends StatefulWidget {
  final Map<LocalPgpKey, bool?> userKeys;
  final Map<LocalPgpKey, bool?> contactKeys;
  final Map<LocalPgpKey, bool?> alienKeys;
  final PgpSettingPresenter presenter;

  const ImportKeyDialog(
    this.userKeys,
    this.contactKeys,
    this.alienKeys,
    this.presenter,
  );

  @override
  _ImportKeyDialogState createState() => _ImportKeyDialogState();
}

class _ImportKeyDialogState extends State<ImportKeyDialog> {
  final List<LocalPgpKey> userKeys = [];
  final List<LocalPgpKey> contactKeys = [];
  final List<LocalPgpKey> alienKeys = [];
  bool areExistingKeys = false;
  bool isProgress = false;
  bool isKeysToImport = false;

  @override
  void initState() {
    super.initState();
    widget.userKeys.forEach((key, value) {
      userKeys.add(key);
      if (value == null) {
        areExistingKeys = true;
      }
    });
    widget.contactKeys.forEach((key, value) {
      contactKeys.add(key);
      if (value == null) {
        areExistingKeys = true;
      }
    });
    widget.alienKeys.forEach((key, value) {
      alienKeys.add(key);
    });
    isKeysToImport = userKeys.isNotEmpty || contactKeys.isNotEmpty;
  }

  @override
  Widget build(BuildContext context) {
    final s = context.l10n;
    return AlertDialog(
      title: Text(s.label_pgp_import_key),
      content: SizedDialogContent(
        child: ListView(
          children: <Widget>[
            if (!isKeysToImport)
              Padding(
                padding: EdgeInsets.only(top: 8, bottom: 32),
                child: Text(s.hint_pgp_no_keys_to_import),
              ),
            if (areExistingKeys)
              Padding(
                padding: EdgeInsets.symmetric(vertical: 8),
                child: Text(s.hint_pgp_already_have_keys),
              ),
            if (userKeys.isNotEmpty && !BuildProperty.legacyPgpKey)
              Padding(
                padding: EdgeInsets.symmetric(vertical: 8),
                child: Text(s.hint_pgp_your_keys),
              ),
            Column(
              children: userKeys.map((key) {
                return KeyItem(
                    pgpKey: key,
                    selected: widget.userKeys[key],
                    onSelect: (select) {
                      setState(() {
                        widget.userKeys[key] = select;
                      });
                    });
              }).toList(),
            ),
            if (!BuildProperty.legacyPgpKey) ...[
              if (contactKeys.isNotEmpty)
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 8),
                  child: Text(s.hint_pgp_keys_will_be_import_to_contacts),
                ),
              Column(
                children: contactKeys.map((key) {
                  return KeyItem(
                      pgpKey: key,
                      selected: widget.contactKeys[key],
                      external: true,
                      onSelect: (select) {
                        setState(() {
                          widget.contactKeys[key] = select;
                        });
                      });
                }).toList(),
              ),
            ],
            if (alienKeys.isNotEmpty) ...[
              Padding(
                padding: EdgeInsets.only(top: 8),
                child: Text(s.hint_pgp_external_private_keys),
              ),
              Column(
                children: alienKeys.map((key) {
                  return KeyItem(
                    pgpKey: key,
                    selected: null,
                    external: true,
                    onSelect: (_) {},
                  );
                }).toList(),
              ),
            ],
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(
          child: Text(s.cancel),
          onPressed: () => Navigator.pop(context),
        ),
        if (isKeysToImport)
          TextButton(
            child: !isProgress
                ? Text(s.btn_pgp_import_selected_key)
                : CircularProgressIndicator(),
            onPressed: _canImport() ? _import : null,
          ),
      ],
    );
  }

  bool _canImport() {
    if (isProgress) return false;
    return widget.userKeys.values.contains(true) ||
        widget.contactKeys.values.contains(true);
  }

  _import() async {
    final userKey = <LocalPgpKey>[];
    final contactKey = <LocalPgpKey>[];
    widget.userKeys.forEach((key, value) {
      if (value ?? false) {
        userKey.add(key);
      }
    });
    widget.contactKeys.forEach((key, value) {
      if (value ?? false) {
        contactKey.add(key);
      }
    });
    try {
      isProgress = true;
      setState(() {});
      await widget.presenter.saveKeys(
        userKey,
        contactKey,
      );
      Navigator.pop(context);
    } catch (e) {
      print(e);
    }
    isProgress = false;
    setState(() {});
  }
}

class CheckAnalog extends StatelessWidget {
  final bool isCheck;
  final Function(bool)? onChange;

  const CheckAnalog(this.isCheck, this.onChange);

  @override
  Widget build(BuildContext context) {
    return PlatformOverride.isIOS
        ? GestureDetector(
            onTap: () {
              if (onChange != null) {
                onChange!(!isCheck);
              }
            },
            child: Padding(
              padding: EdgeInsets.all(10),
              child: Icon(
                isCheck ? Icons.check_box : Icons.check_box_outline_blank,
                color: onChange == null ? Colors.grey : null,
              ),
            ),
          )
        : Checkbox(
            value: isCheck,
            onChanged: (value) {
              if (onChange != null && value != null) {
                onChange!(value);
              }
            },
          );
  }
}
