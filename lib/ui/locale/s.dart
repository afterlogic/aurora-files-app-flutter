//base class strings
//and en locale
import 'package:aurorafiles/ui/view/provider_widget.dart';
import 'package:flutter/widgets.dart';

class S {
  final host = "Host";
  final enterHost = "Please enter hostname";
  final enterEmail = "Please enter email";
  final enterPassword = "Please enter password";
  final login = "Login";
  final email = "Email";
  final password = "Password";
  final hostRequired =
      "Could not detect domain from this email, please specify your server url manually.";

  final upgradeText =
      "Mobile apps are not allowed in your billing plan.\nPlease upgrade your plan.";

  final upgradeNow = "Upgrade now";

  final backToLogin = "Back to login";

  final tryAgain = "Please, try again";

  final invalidLogin = "Invalid login/password";

  static S of(BuildContext context) {
    return ProviderWidget.of<S>(context);
  }
}
