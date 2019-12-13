import 'package:aurorafiles/generated/i18n.dart';
import 'package:aurorafiles/modules/app_store.dart';
import 'package:aurorafiles/shared_ui/app_button.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:url_launcher/url_launcher.dart';

class StorageInfoDialog extends StatelessWidget {
  final _quota = AppStore.filesState.quota;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final s = S.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(s.storage_info),
      ),
      body: _quota == null
          ? Padding(
        padding: const EdgeInsets.all(18.0),
        child: Row(
          children: <Widget>[
            Icon(Icons.error),
            SizedBox(width: 18.0),
            Flexible(
                child: Text(
                    AppStore.filesState.isOfflineMode
                        ? s.offline_information_is_not_available
                        : s.information_is_not_available,
                    style: theme.textTheme.subhead)),
          ],
        ),
      )
          : ListView(
        padding: EdgeInsets.all(16.0),
        children: <Widget>[
          CircularPercentIndicator(
            percent: _quota.progress,
            backgroundColor: theme.disabledColor.withOpacity(0.25),
            circularStrokeCap: CircularStrokeCap.round,
            animateFromLastPercent: true,
            progressColor: theme.accentColor,
            center: Text("${(_quota.progress * 100).round()}%",
                style: theme.textTheme.title),
            radius: 100.0,
          ),
          SizedBox(height: 32.0),
          Text(
            s.available_space(_quota.availableFormatted),
            style: theme.textTheme.subhead,
          ),
          SizedBox(height: 22.0),
          Text(
              s.used_space(_quota.usedFormatted, _quota
                  .limitFormatted),
              style: theme.textTheme.subhead),
          SizedBox(height: 46.0),
          AppButton(
            text: s.upgrade_now,
            onPressed: () =>
                launch(
                    "https://privatemail.com/members/supporttickets.php"),
          )
        ],
      ),
    );
  }
}
