import 'package:aurorafiles/database/app_database.dart';
import 'package:aurorafiles/modules/files/state/files_page_state.dart';
import 'package:aurorafiles/modules/files/state/files_state.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// wrapper for file items
class SelectableFilesItemTile extends StatelessWidget {
  final Widget child;
  final LocalFile file;
  final bool isSelected;
  final Function onTap;

  const SelectableFilesItemTile(
      {Key? key,
      required this.child,
      this.isSelected = false,
      this.file,
      this.onTap})
      : super(key: key);

  Function _getOnTapCb(FilesState filesState, FilesPageState filesPageState) {
    if ((file != null &&
            file.isFolder &&
            filesState.filesToMoveCopy.contains(file)) ||
        file?.extendedProps == "fake") {
      return null;
    }
    if (filesPageState.filesLoading == FilesLoadingType.filesHidden ||
        filesState.isMoveModeEnabled && file != null && !file.isFolder) {
      return null;
    } else if (filesPageState.selectedFilesIds.length > 0) {
      return () => filesPageState.selectFile(file);
    } else {
      return () => onTap();
    }
  }

  Widget _buildSelectionOverlay(BuildContext context) {
    final thumbnailSize = Provider.of<FilesState>(context).filesTileLeadingSize;
    return Container(
      color: Theme.of(context).selectedRowColor.withOpacity(0.5),
      child: Column(
        children: <Widget>[
          SizedBox(height: 6.0),
          ListTile(
            leading: SizedBox(
              width: thumbnailSize,
              height: thumbnailSize,
              child: Icon(Icons.check_circle, color: Colors.white),
            ),
          ),
          SizedBox(height: 6.0),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final filesState = Provider.of<FilesState>(context);
    final filesPageState = Provider.of<FilesPageState>(context);

    return InkWell(
      onTap: _getOnTapCb(filesState, filesPageState),
      onLongPress: filesState.isOfflineMode ||
              filesState.isMoveModeEnabled ||
              file == null ||
              file.extendedProps == "fake" ||
              filesPageState.selectedFilesIds.length > 0
          ? null
          : () => filesPageState.selectFile(file),
      child: Stack(
        children: <Widget>[
          Column(
            children: <Widget>[
              SizedBox(height: 6.0),
              child,
              SizedBox(height: 6.0),
            ],
          ),
          if (isSelected) _buildSelectionOverlay(context),
        ],
      ),
    );
  }
}
