import 'package:aurorafiles/database/app_database.dart';
import 'package:aurorafiles/build_property.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class KeyWidget extends StatelessWidget {
  final LocalPgpKey pgpKey;
  final Function(LocalPgpKey pgpKey) openKey;

  const KeyWidget(this.pgpKey, this.openKey, {super.key});

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
            const Divider(
              color: Colors.transparent,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  pgpKey.email,
                  maxLines: 1,
                  style: theme.textTheme.subtitle1,
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 16),
                  child: pgpKey.key.isEmpty
                      ? const SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator())
                      : BuildProperty.flatDesign
                          ? SvgPicture.asset(
                              '${BuildProperty.imageDir}/settings/open-pgp/arrow-right.svg',
                              width: 24,
                              height: 24,
                            )
                          : const Icon(Icons.arrow_forward_ios),
                ),
              ],
            ),
            const Divider(
              color: Colors.grey,
            ),
          ],
        ),
      ),
    );
  }
}
