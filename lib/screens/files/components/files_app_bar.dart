import 'package:aurorafiles/screens/files/dialogs_android/add_folder_dialog_android.dart';
import 'package:aurorafiles/screens/files/dialogs_android/move_options_bottom_sheet.dart';
import 'package:aurorafiles/screens/files/state/files_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';

class FilesAppBar extends StatefulWidget with PreferredSizeWidget {
  final Function(BuildContext) onDeleteFiles;

  FilesAppBar({Key key, @required this.onDeleteFiles}) : super(key: key);

  @override
  _FilesAppBarState createState() => _FilesAppBarState();

  @override
  Size get preferredSize => new Size.fromHeight(AppBar().preferredSize.height);
}

class _FilesAppBarState extends State<FilesAppBar>
    with TickerProviderStateMixin {
  FilesState _filesState;
  AnimationController _appBarIconAnimCtrl;

  @override
  void initState() {
    _appBarIconAnimCtrl = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    );
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _appBarIconAnimCtrl.dispose();
  }

  void _showPersistentBottomSheet(context) {
    showBottomSheet(
      context: context,
      builder: (_) => MoveOptionsBottomSheet(filesState: _filesState),
    );
  }

  Widget _getTitle(BuildContext context) {
    final bool isSelectMode = _filesState.selectedFilesIds.length > 0;
    if (_filesState.isMoveModeEnabled) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text("Move files/folders"),
          SizedBox(height: 2),
          Text(
            _filesState.currentFilesType,
            style: TextStyle(fontSize: 10.0),
          )
        ],
      );
    } else if (isSelectMode) {
      return Text("Selected: ${_filesState.selectedFilesIds.length}");
    } else {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text("Files"),
          SizedBox(height: 2),
          Text(
            _filesState.currentFilesType,
            style: TextStyle(fontSize: 10.0),
          )
        ],
      );
    }
  }

  List<IconButton> _getAppbarActions(BuildContext context) {
    if (_filesState.isMoveModeEnabled) {
      return [
        IconButton(
          icon: Icon(Icons.create_new_folder),
          tooltip: "Add folder",
          onPressed: () => showDialog(
            context: context,
            barrierDismissible: false,
            builder: (_) => AddFolderDialogAndroid(
              filesState: _filesState,
            ),
          ),
        ),
      ];
    } else if (_filesState.selectedFilesIds.length > 0) {
      return [
        IconButton(
          icon: Icon(Icons.exit_to_app),
          tooltip: "Move/Copy files",
          onPressed: () {
            _showPersistentBottomSheet(context);
            _filesState.enableMoveMode();
          },
        ),
        IconButton(
          icon: Icon(Icons.delete_outline),
          tooltip: "Delete files",
          onPressed: () => widget.onDeleteFiles(context),
        ),
      ];
    } else {
      return [
        IconButton(
          icon: Icon(Icons.search),
          tooltip: "Search",
          onPressed: () {},
        ),
      ];
    }
  }

  @override
  Widget build(BuildContext context) {
    _filesState = Provider.of<FilesState>(context);

    return Observer(
      builder: (_) {
        final bool isSelectMode = _filesState.selectedFilesIds.length > 0;
        if (isSelectMode)
          _appBarIconAnimCtrl.forward();
        else
          _appBarIconAnimCtrl.reverse();

        return AppBar(
          leading: IconButton(
            icon: AnimatedIcon(
              icon: AnimatedIcons.menu_close,
              progress: _appBarIconAnimCtrl,
            ),
            onPressed: isSelectMode
                ? () => _filesState.selectedFilesIds = new Set()
                : () => Scaffold.of(context).openDrawer(),
          ),
          title: _getTitle(context),
          actions: _getAppbarActions(context),
        );
      },
    );
  }
}
