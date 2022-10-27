import 'package:aurorafiles/l10n/l10n.dart';
import 'package:aurorafiles/modules/files/state/files_page_state.dart';
import 'package:aurorafiles/modules/files/state/files_state.dart';
import 'package:aurorafiles/utils/show_snack.dart';
import 'package:flutter/material.dart';

class MoveOptions extends StatefulWidget {
  final FilesState filesState;
  final FilesPageState filesPageState;

  const MoveOptions({
    Key? key,
    required this.filesState,
    required this.filesPageState,
  }) : super(key: key);

  @override
  _MoveOptionsState createState() => _MoveOptionsState();
}

class _MoveOptionsState extends State<MoveOptions> {
  bool _buttonsDisabled = false;

  void _moveFiles(BuildContext context, bool copy) {
    widget.filesPageState.filesLoading = FilesLoadingType.filesVisible;
    setState(() => _buttonsDisabled = true);
    widget.filesState.onCopyMoveFiles(
        toPath: widget.filesPageState.pagePath,
        copy: copy,
        onSuccess: () async {
          await widget.filesPageState.onGetFiles(
            onError: (String err) => showSnack(context, msg: err),
          );
          setState(() => _buttonsDisabled = false);
          widget.filesState.disableMoveMode();
        },
        onError: (err) {
          setState(() => _buttonsDisabled = false);
          widget.filesPageState.filesLoading = FilesLoadingType.none;
          showSnack(context, msg: err);
        });
  }

  @override
  Widget build(BuildContext context) {
    final s = context.l10n;
    final textColor = Theme.of(context).iconTheme.color;
    return Container(
      decoration: BoxDecoration(
        border: const Border(top: BorderSide(color: Colors.grey)),
        color: Theme.of(context).scaffoldBackgroundColor,
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(top: 3.0, bottom: 6.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              TextButton(
                child: Text(
                  s.cancel,
                  style: TextStyle(color: textColor),
                ),
                onPressed: () {
                  widget.filesState.disableMoveMode();
                },
              ),
              TextButton(
                onPressed:
                    _buttonsDisabled ? null : () => _moveFiles(context, true),
                child: Text(
                  s.copy,
                  style: TextStyle(color: textColor),
                ),
              ),
              TextButton(
                onPressed:
                    _buttonsDisabled ? null : () => _moveFiles(context, false),
                child: Text(
                  s.move,
                  style: TextStyle(color: textColor),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
