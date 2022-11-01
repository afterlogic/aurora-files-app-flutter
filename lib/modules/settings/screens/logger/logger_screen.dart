import 'package:aurora_logger/aurora_logger.dart';
import 'package:aurora_ui_kit/aurora_ui_kit.dart';
import 'package:aurorafiles/l10n/l10n.dart';
import 'package:aurorafiles/modules/app_store.dart';
import 'package:aurorafiles/modules/settings/repository/settings_local_storage.dart';
import 'package:aurorafiles/shared_ui/layout_config.dart';
import 'package:flutter/material.dart';

class LoggerScreen extends StatefulWidget {
  const LoggerScreen({super.key});

  @override
  _LoggerScreenState createState() => _LoggerScreenState();
}

class _LoggerScreenState extends State<LoggerScreen> {
  final _storage = SettingsLocalStorage();
  late bool _showResponseBody;
  bool _initComplete = false;

  @override
  void initState() {
    super.initState();
    _initSettings();
  }

  Future<void> _initSettings() async {
    _showResponseBody = await _storage.getShowResponseBody();
    _initComplete = true;
    if (mounted) setState(() {});
  }

  void _updateShowResponseBody(bool? value) {
    if (value == null) return;
    setState(() {
      _showResponseBody = value;
    });
    _storage.setShowResponseBody(value);
  }

  @override
  Widget build(BuildContext context) {
    final s = context.l10n;
    final isTablet = LayoutConfig.of(context).isTablet;
    return Scaffold(
      appBar: isTablet
          ? null
          : const AMAppBar(
              title: Text("Debug"),
            ),
      body: _initComplete == false
          ? const SizedBox.shrink()
          : Column(
              children: [
                CheckboxListTile(
                  value: _showResponseBody,
                  title: const Text('Show response body'),
                  onChanged: _updateShowResponseBody,
                ),
                Expanded(
                  child: LoggerSettingWidget(
                    LoggerSettingArg(
                        AppStore.authState.apiUrl,
                        s.logger_label_show_debug_view,
                        s.logger_btn_delete_all,
                        s.logger_hint_delete_all_logs,
                        s.logger_hint_delete_log, (hint) async {
                      final result = await AMConfirmationDialog.show(
                        context,
                        "",
                        hint,
                        s.delete,
                        s.cancel,
                      );
                      if (result == true) {
                        return true;
                      } else {
                        return false;
                      }
                    }),
                  ),
                ),
              ],
            ),
    );
  }
}
