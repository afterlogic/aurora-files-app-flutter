import 'package:aurorafiles/screens/files/state/files_page_state.dart';
import 'package:aurorafiles/screens/files/state/files_state.dart';
import 'package:aurorafiles/utils/show_snack.dart';
import 'package:flutter/material.dart';

class MoveOptions extends StatelessWidget {
  final FilesState filesState;
  final FilesPageState filesPageState;

  const MoveOptions({
    Key key,
    @required this.filesState,
    @required this.filesPageState,
  }) : super(key: key);

  void _moveFiles(BuildContext context, bool copy) {
    filesPageState.filesLoading = FilesLoadingType.filesVisible;
    filesState.onCopyMoveFiles(
        toPath: filesPageState.pagePath,
        copy: copy,
        onSuccess: () async {
          await filesPageState.onGetFiles(
            path: filesPageState.pagePath,
            storage: filesState.selectedStorage,
            onError: (String err) => showSnack(
              context: context,
              scaffoldState: filesPageState.scaffoldKey.currentState,
              msg: err,
            ),
          );
          filesState.disableMoveMode();
        },
        onError: (err) {
          filesPageState.filesLoading = FilesLoadingType.none;
          showSnack(
            context: context,
            scaffoldState: filesPageState.scaffoldKey.currentState,
            msg: err,
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: Colors.grey)),
        color: Theme.of(context).scaffoldBackgroundColor,
      ),
      child: Padding(
        padding: const EdgeInsets.only(top: 3.0, bottom: 6.0),
        child: SafeArea(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              FlatButton(
                child: Text("Cancel"),
                onPressed: () {
                  filesState.disableMoveMode();
                },
              ),
              FlatButton(
                child: Text("Copy"),
                onPressed: () => _moveFiles(context, true),
              ),
              FlatButton(
                child: Text("Move"),
                onPressed: () => _moveFiles(context, false),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
