import 'package:aurorafiles/database/app_database.dart';

extension NameUtil on LocalPgpKey {
  String formatName() {
    return IdentityView.solid(name, email);
  }
}

class IdentityView {
  final String email;
  final String name;

  IdentityView(this.email, this.name);

  static IdentityView fromString(String string) {
    final groups = RegExp("([\\D|\\d]*)?<((?:\\D|\\d)*)>").firstMatch(string);
    String validEmail = "";
    String name = "";
    if (groups?.groupCount == 2) {
      name = groups?.group(1) ?? '';
      validEmail = groups?.group(2) ?? '';
    } else {
      validEmail = string;
    }
    return IdentityView(validEmail, name);
  }

  static String solid(String name, String mail) {
    return (name.isNotEmpty ? "$name " : "") + "<$mail>";
  }
}
