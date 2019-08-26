import 'package:aurorafiles/screens/files/state/files_page_state.dart';
import 'package:aurorafiles/screens/files/state/files_state.dart';
import 'package:aurorafiles/utils/show_snack.dart';
import 'package:flutter/material.dart';

class MoveOptionsBottomSheet extends StatelessWidget {
  final FilesState filesState;
  final FilesPageState filesPageState;

  const MoveOptionsBottomSheet({
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
          Navigator.pop(context);
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
    return BottomSheet(
      builder: (_) => Container(
        decoration: BoxDecoration(
          border: Border(top: BorderSide(color: Colors.black12)),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 3.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              FlatButton(
                child: Text("Cancel", style: TextStyle(color: Colors.black)),
                onPressed: () {
                  filesState.disableMoveMode();
                  Navigator.pop(context);
                },
              ),
              FlatButton(
                child: Text("Copy", style: TextStyle(color: Colors.black)),
                onPressed: () => _moveFiles(context, true),
              ),
              FlatButton(
                child: Text("Move", style: TextStyle(color: Colors.black)),
                onPressed: () => _moveFiles(context, false),
              ),
            ],
          ),
        ),
      ),
      onClosing: () {
        filesState.disableMoveMode();
        Navigator.pop(context);
      },
    );
  }
}
