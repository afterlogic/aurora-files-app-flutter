import 'dart:math';

import 'package:aurora_ui_kit/aurora_ui_kit.dart';
import 'package:aurorafiles/database/app_database.dart';
import 'package:aurorafiles/generated/s_of_context.dart';
import 'package:aurorafiles/modules/settings/repository/pgp_key_util.dart';
import 'package:aurorafiles/override_platform.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ImportPgpKeyWidget extends StatefulWidget {
  final List<LocalPgpKey> keys;
  final PgpKeyUtil pgpKeyUtil;

  ImportPgpKeyWidget(this.keys, this.pgpKeyUtil);

  @override
  _ImportPgpKeyWidgetState createState() => _ImportPgpKeyWidgetState();
}

class _ImportPgpKeyWidgetState extends State<ImportPgpKeyWidget> {
  Map<String, LocalPgpKey> selected = {};
  bool isHaveKey = false;

  @override
  void initState() {
    super.initState();
    checkKeys();
  }

  checkKeys() async {
    final keys = await widget.pgpKeyUtil.checkHasKeys(widget.keys);
    for (LocalPgpKey key in widget.keys) {
      selected[key.email + key.isPrivate.toString()] = key;
    }
    for (LocalPgpKey key in keys) {
      selected.remove(key.email + key.isPrivate.toString());
    }
    if (keys.isNotEmpty) {
      isHaveKey = true;
    }
    setState(() {});
  }

  changeSelected(bool isSelected, LocalPgpKey key) {
    if (isSelected) {
      selected[key.email + key.isPrivate.toString()] = key;
    } else {
      selected.remove(key.email + key.isPrivate.toString());
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final s = Str.of(context);
    final size = MediaQuery.of(context).size;
    final title = Text("Import keys");
    final content = Flex(
      direction: Axis.vertical,
      children: <Widget>[
        if (isHaveKey) Text(s.already_have_keys),
        Expanded(
          child: ListView.builder(
            itemBuilder: (_, i) {
              final key = widget.keys[i];
              final isSelected =
                  selected.containsKey(key.email + key.isPrivate.toString());
              return KeyItem(key, isSelected, (bool, key) {
                if (bool) {
                  selected[key.email + key.isPrivate.toString()] = key;
                } else {
                  selected.remove(key.email + key.isPrivate.toString());
                }
                setState(() {});
              });
            },
            itemCount: widget.keys.length,
          ),
        ),
        SizedBox(
          width: double.infinity,
          child: AMButton(
              child: Text(s.import_selected_keys),
              onPressed: () {
                Navigator.pop(context, selected.values.toList());
              }),
        ),
        SizedBox(
          width: double.infinity,
          child: AMButton(
              child: Text(s.cancel), onPressed: () => Navigator.pop(context)),
        ),
      ],
    );

    return PlatformOverride.isIOS
        ? CupertinoAlertDialog(
            title: title,
            content: SizedBox(
              height: size.height / 2,
              width: min(size.width - 40, 300),
              child: content,
            ),
          )
        : AlertDialog(
            title: title,
            content: SizedBox(
                height: size.height / 2,
                width: min(size.width - 40, 300),
                child: content),
          );
  }
}

class KeyItem extends StatefulWidget {
  final LocalPgpKey pgpKey;
  final bool selected;
  final Function(bool, LocalPgpKey) onSelect;

  const KeyItem(this.pgpKey, this.selected, this.onSelect);

  @override
  _KeyItemState createState() => _KeyItemState();
}

class _KeyItemState extends State<KeyItem> {
  @override
  Widget build(BuildContext context) {
    final description = widget.pgpKey.key.length != null
        ? "(${widget.pgpKey.length}-bit, ${widget.pgpKey.isPrivate ? "private" : "public"})"
        : "( ${widget.pgpKey.isPrivate ? "private" : "public"})";

    var textTheme = Theme.of(context).textTheme;
    if (!widget.selected) {
      textTheme = textTheme.apply(bodyColor: Colors.grey);
      textTheme = textTheme.apply(displayColor: Colors.grey);
    }

    return Column(
      children: <Widget>[
        Divider(
          color: Colors.transparent,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  widget.pgpKey.email,
                  style: textTheme.body1,
                ),
                Text(
                  description,
                  style: textTheme.caption,
                ),
              ],
            ),
            CheckAnalog(widget.selected, (isSelected) {
              widget.onSelect(isSelected, widget.pgpKey);
            })
          ],
        ),
        Divider(
          color: Colors.grey,
        ),
      ],
    );
  }
}

class CheckAnalog extends StatelessWidget {
  final bool isCheck;
  final Function(bool) onChange;

  const CheckAnalog(this.isCheck, this.onChange);

  @override
  Widget build(BuildContext context) {
    return PlatformOverride.isIOS
        ? GestureDetector(
            onTap: () => onChange(!isCheck),
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
            onChanged: onChange,
          );
  }
}
