import 'package:aurorafiles/screens/files/state/files_state.dart';
import 'package:flutter/material.dart';

class MoveOptionsBottomSheet extends StatelessWidget {
  final FilesState filesState;

  const MoveOptionsBottomSheet({Key key, this.filesState}) : super(key: key);

  void _showErrSnack(BuildContext context, String err) {
    filesState.scaffoldKey.currentState.showSnackBar(SnackBar(
        elevation: 80.0, content: Text(err), backgroundColor: Theme.of(context).errorColor));
  }

  void _moveFiles(BuildContext context, bool copy) {
    filesState.filesLoading = FilesLoadingType.filesVisible;
    filesState.onCopyMoveFiles(
        copy: copy,
        onSuccess: () async {
          await filesState.onGetFiles(
            path: filesState.currentPath,
            onError: (String err) => _showErrSnack(context, err),
          );
          filesState.disableMoveMode();
          Navigator.pop(context);
        },
        onError: (err) {
          filesState.filesLoading = FilesLoadingType.none;
          _showErrSnack(context, err);
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
