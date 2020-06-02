import 'package:aurorafiles/utils/identity_util.dart';
import 'package:aurorafiles/database/app_database.dart';
import 'package:flutter/material.dart';

class KeyItem extends StatefulWidget {
  final LocalPgpKey pgpKey;
  final bool selected;
  final Function(bool) onSelect;

  const KeyItem(this.pgpKey, this.selected, this.onSelect);

  @override
  _KeyItemState createState() => _KeyItemState();
}

class _KeyItemState extends State<KeyItem> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    var textTheme = theme.textTheme;

    final length = widget.pgpKey.key?.length != null
        ? "(${widget.pgpKey.length}-bit,"
        : "(";

    final description =
        "$length ${widget.pgpKey.isPrivate ? "private" : "public"})";

    if (widget.selected != true && widget.onSelect != null) {
      textTheme = textTheme.apply(
        bodyColor: Colors.grey,
        displayColor: Colors.grey,
      );
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Divider(
          color: Colors.transparent,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      widget.pgpKey.formatName(),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                      style: textTheme.body1,
                    ),
                    Text(
                      description,
                      style: textTheme.caption,
                    ),
                  ],
                ),
              ),
            ),
            if (widget.selected != null)
              Checkbox(
                value: widget.selected,
                onChanged: (isSelected) {
                  widget.onSelect(isSelected);
                },
              )
          ],
        ),
        Divider(
          color: Colors.grey,
        ),
      ],
    );
  }
}
