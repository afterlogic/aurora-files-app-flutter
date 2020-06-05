import 'package:aurorafiles/database/app_database.dart';
import 'package:flutter/material.dart';

class KeyWidget extends StatelessWidget {
  final LocalPgpKey pgpKey;
  final Function(LocalPgpKey pgpKey) openKey;

  const KeyWidget(this.pgpKey, this.openKey);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SizedBox(
      height: 60,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          openKey(pgpKey);
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Divider(
              color: Colors.transparent,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  pgpKey.email,
                  maxLines: 1,
                  style: theme.textTheme.subhead,
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 16),
                  child: pgpKey.key == null
                      ? SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator())
                      : Icon(Icons.arrow_forward_ios),
                ),
              ],
            ),
            Divider(
              color: Colors.grey,
            ),
          ],
        ),
      ),
    );
  }
}
