import 'package:aurorafiles/database/app_database.dart';
import 'package:aurorafiles/screens/files/state/files_state.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// wrapper for file items
class SelectableFilesItemTile extends StatelessWidget {
  final ListTile child;
  final File file;
  final bool isSelected;
  final Function onTap;

  const SelectableFilesItemTile(
      {Key key,
      @required this.child,
      this.isSelected = false,
      this.file,
      this.onTap})
      : super(key: key);

  Function _getOnTapCb(FilesState filesState) {
    if (filesState.mode == Modes.move && file != null && !file.isFolder) {
      return null;
    } else if (filesState.selectedFilesIds.length > 0) {
      return () => filesState.selectFile(file.id);
    } else {
      return () => onTap();
    }
  }

  Widget _buildSelectionOverlay(BuildContext context) {
    final thumbnailSize = Provider.of<FilesState>(context).filesTileLeadingSize;
    return Container(
      color: Theme.of(context).selectedRowColor,
      child: Column(
        children: <Widget>[
          SizedBox(height: 6.0),
          ListTile(
            leading: SizedBox(
              width: thumbnailSize,
              height: thumbnailSize,
              child:
                  Icon(Icons.check_circle, color: Theme.of(context).cardColor),
            ),
          ),
          SizedBox(height: 6.0),
          Padding(
            padding: const EdgeInsets.only(left: 80.0),
            child: Divider(height: 0.0),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final filesState = Provider.of<FilesState>(context);

    return InkWell(
      onTap: _getOnTapCb(filesState),
      onLongPress: filesState.mode == Modes.move ||
              file == null ||
              filesState.selectedFilesIds.length > 0
          ? null
          : () => filesState.selectFile(file.id),
      child: Stack(
        children: <Widget>[
          Column(
            children: <Widget>[
              SizedBox(height: 6.0),
              child,
              SizedBox(height: 6.0),
              Padding(
                padding: const EdgeInsets.only(left: 80.0),
                child: Divider(height: 0.0),
              ),
            ],
          ),
          if (isSelected) _buildSelectionOverlay(context),
        ],
      ),
    );
  }
}
