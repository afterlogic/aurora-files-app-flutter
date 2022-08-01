import 'package:aurorafiles/build_property.dart';
import 'package:aurorafiles/generated/s_of_context.dart';
import 'package:flutter/material.dart';

import 'mail_logo.dart';

class PresentationHeader extends StatelessWidget {
  final String message;

  const PresentationHeader({Key key, this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final s = Str.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        MailLogo(),
        if (!BuildProperty.useMainLogo) ...[
          SizedBox(height: 26.0),
          Text(
            BuildProperty.appName,
            style: Theme.of(context).textTheme.headline4,
          ),
          SizedBox(height: 12.0),
          Text(
            message ?? s.login_to_continue,
            style: TextStyle(color: Theme.of(context).disabledColor),
          ),
        ]
      ],
    );
  }
}
