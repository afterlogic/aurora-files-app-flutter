import 'package:aurorafiles/generated/string/en_string.dart';
import 'package:aurorafiles/generated/string/s.dart';
import 'package:flutter/widgets.dart';

import 'localization_string_widget.dart';

export 'string/s.dart';

class Str {
  static S of(BuildContext context) =>
      Localizations.of<LocalizationStringWidget>(
              context, LocalizationStringWidget)
          ?.s ??
      EnString();
}
