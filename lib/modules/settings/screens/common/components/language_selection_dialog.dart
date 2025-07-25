import 'package:aurora_ui_kit/aurora_ui_kit.dart';
import 'package:aurorafiles/l10n/l10n.dart';
import 'package:aurorafiles/modules/settings/models/language.dart';
import 'package:flutter/material.dart';

class LanguageSelectionDialog extends StatelessWidget {
  final Language? selectedItem;
  final Function(Language?) onItemSelected;

  const LanguageSelectionDialog(this.onItemSelected, this.selectedItem,
      {super.key});

  static void show(BuildContext context, Language? selected,
      Function(Language?) onItemSelected) {
    AMDialog.show(
        context: context,
        builder: (_) => LanguageSelectionDialog(onItemSelected, selected));
  }

  @override
  Widget build(BuildContext context) {
    final s = context.l10n;
    final theme = Theme.of(context);

    return AMDialog(
      contentPadding: EdgeInsets.zero,
      titlePadding: const EdgeInsets.all(24.0),
      title: Text(s.switch_language),
      content: SizedBox(
        width: MediaQuery.of(context).size.width > 600 ? 400 : double.maxFinite,
        child: AMDialogList(
          children: Language.availableLanguages
              .map(
                (lang) => RadioListTile<String>(
                  activeColor: theme.primaryColor,
                  title: Text(lang == null
                      ? s.system_language
                      : lang.name),
                  value: lang?.tag ?? 'system',
                  groupValue: selectedItem?.tag ?? 'system',
                  onChanged: (val) {
                    onItemSelected(lang);
                    Navigator.pop(context);
                  },
                ),
              )
              .toList(),
        ),
      ),
      actions: <Widget>[
        TextButton(
          onPressed: Navigator.of(context).pop,
          child: Text(s.cancel),
        ),
      ],
    );
  }
}
