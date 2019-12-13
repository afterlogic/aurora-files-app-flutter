import 'package:aurorafiles/generated/i18n.dart';
import 'package:aurorafiles/modules/files/state/files_page_state.dart';
import 'package:aurorafiles/modules/files/state/files_state.dart';
import 'package:aurorafiles/utils/show_snack.dart';
import 'package:flutter/material.dart';

class MoveOptions extends StatefulWidget {
  final FilesState filesState;
  final FilesPageState filesPageState;

  const MoveOptions({
    Key key,
    @required this.filesState,
    @required this.filesPageState,
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
            onError: (String err) => showSnack(
              context: context,
              scaffoldState: widget.filesPageState.scaffoldKey.currentState,
              msg: err,
            ),
          );
          setState(() => _buttonsDisabled = false);
          widget.filesState.disableMoveMode();
        },
        onError: (err) {
          setState(() => _buttonsDisabled = false);
          widget.filesPageState.filesLoading = FilesLoadingType.none;
          showSnack(
            context: context,
            scaffoldState: widget.filesPageState.scaffoldKey.currentState,
            msg: err,
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    return Container(
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: Colors.grey)),
        color: Theme.of(context).scaffoldBackgroundColor,
      ),
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(top: 3.0, bottom: 6.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              FlatButton(
                child: Text(s.cancel),
                textColor: Theme.of(context).iconTheme.color,
                onPressed: () {
                  widget.filesState.disableMoveMode();
                },
              ),
              FlatButton(
                child: Text(s.copy),
                textColor: Theme.of(context).iconTheme.color,
                onPressed:
                _buttonsDisabled ? null : () => _moveFiles(context, true),
              ),
              FlatButton(
                child: Text(s.move),
                textColor: Theme.of(context).iconTheme.color,
                onPressed:
                _buttonsDisabled ? null : () => _moveFiles(context, false),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
