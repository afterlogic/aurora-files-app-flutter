import 'package:aurora_ui_kit/aurora_ui_kit.dart';
import 'package:aurorafiles/l10n/l10n.dart';
import 'package:flutter/material.dart';

class ThemeSelectionDialog extends StatelessWidget {
  final bool theme;
  final Function(bool?) onItemSelected;

  const ThemeSelectionDialog(this.onItemSelected, this.theme);

  static void show(
    BuildContext context,
    bool selected,
    Function(bool?) onItemSelected,
  ) {
    AMDialog.show(
      context: context,
      builder: (_) => ThemeSelectionDialog(onItemSelected, selected),
    );
  }

  @override
  Widget build(BuildContext context) {
    final s = context.l10n;
    return AMDialog(
      contentPadding: EdgeInsets.zero,
      titlePadding: EdgeInsets.all(24.0),
      title: Text(s.app_theme),
      content: AMDialogList(
        children: [
          RadioListTile<bool?>(
            activeColor: Theme.of(context).colorScheme.secondary,
            title: Text(s.system_theme),
            value: null,
            groupValue: theme,
            onChanged: (val) {
              onItemSelected(null);
              Navigator.pop(context);
            },
          ),
          RadioListTile<bool>(
            activeColor: Theme.of(context).colorScheme.secondary,
            title: Text(s.dark_theme),
            value: true,
            groupValue: theme,
            onChanged: (val) {
              onItemSelected(true);
              Navigator.pop(context);
            },
          ),
          RadioListTile<bool>(
            activeColor: Theme.of(context).colorScheme.secondary,
            title: Text(s.light_theme),
            value: false,
            groupValue: theme,
            onChanged: (val) {
              onItemSelected(false);
              Navigator.pop(context);
            },
          ),
        ],
      ),
      actions: <Widget>[
        TextButton(
          child: Text(s.cancel),
          onPressed: Navigator.of(context).pop,
        ),
      ],
    );
  }
}
