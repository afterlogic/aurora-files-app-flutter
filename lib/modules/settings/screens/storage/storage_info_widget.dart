import 'package:aurorafiles/generated/s_of_context.dart';
import 'package:aurorafiles/modules/app_store.dart';
import 'package:aurorafiles/build_property.dart';
import 'package:aurorafiles/shared_ui/layout_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:aurora_ui_kit/aurora_ui_kit.dart';

class StorageInfoWidget extends StatelessWidget {
  final bool fromDrawer;

  const StorageInfoWidget({this.fromDrawer = false});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final s = Str.of(context);
    final isTablet = LayoutConfig.of(context).isTablet;
    return Scaffold(
      appBar: isTablet && !fromDrawer
          ? null
          : AMAppBar(
              title: Text(s.storage_info),
            ),
      body: AppStore.filesState.quota == null
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
          : RefreshIndicator(
              onRefresh: AppStore.filesState.refreshQuota,
              child: Observer(
                builder: (_) {
                  final quota = AppStore.filesState.quota;

                  return ListView(
                    padding: EdgeInsets.all(16.0),
                    children: <Widget>[
                      CircularPercentIndicator(
                        percent: quota.progress,
                        backgroundColor: theme.disabledColor.withOpacity(0.25),
                        circularStrokeCap: CircularStrokeCap.round,
                        animateFromLastPercent: true,
                        progressColor: theme.accentColor,
                        center: Text("${(quota.progress * 100).round()}%",
                            style: theme.textTheme.title),
                        radius: 100.0,
                      ),
                      SizedBox(height: 32.0),
                      Text(
                        s.available_space(quota.availableFormatted),
                        style: theme.textTheme.subhead,
                      ),
                      SizedBox(height: 22.0),
                      Text(
                          s.used_space(
                              quota.usedFormatted, quota.limitFormatted),
                          style: theme.textTheme.subhead),
                      SizedBox(height: 46.0),
                      // if (BuildProperty.canUpgradePlan)
                      //   SizedBox(
                      //     width: double.infinity,
                      //     child: AMButton(
                      //       child: Text(s.upgrade_now),
                      //       onPressed: () => launch(
                      //           "https://privatemail.com/members/supporttickets.php"),
                      //     ),
                      //   )
                    ],
                  );
                },
              ),
            ),
    );
  }
}
