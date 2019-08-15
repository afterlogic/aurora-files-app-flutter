import 'package:aurorafiles/screens/file_viewer/file_viewer_route.dart';
import 'package:aurorafiles/screens/files/components/file_options_bottom_sheet.dart';
import 'package:aurorafiles/screens/files/state/files_state.dart';
import 'package:aurorafiles/store/app_state.dart';
import 'package:aurorafiles/utils/date_formatting.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:filesize/filesize.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';

import 'files_item_tile.dart';

class FileWidget extends StatelessWidget {
  final file;

  const FileWidget({Key key, @required this.file}) : super(key: key);

  void _showModalBottomSheet(context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.0)),
      ),
      builder: (_) => FileOptionsBottomSheet(
          file: file, filesState: Provider.of<FilesState>(context)),
    );
  }

  Widget _getThumbnail(BuildContext context) {
    final thumbnailSize = Provider.of<FilesState>(context).filesTileLeadingSize;

    if (file["ThumbnailUrl"] != null) {
      return SizedBox(
        width: thumbnailSize,
        height: thumbnailSize,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(5.0),
          child: Container(
            decoration: BoxDecoration(
                image: DecorationImage(
                    fit: BoxFit.cover,
                    image:
                        AssetImage("lib/assets/images/image_placeholder.jpg"))),
            child: Hero(
              tag: file["ThumbnailUrl"],
              child: CachedNetworkImage(
                imageUrl:
                    '${SingletonStore.instance.hostName}/${file["ThumbnailUrl"]}',
                httpHeaders: {
                  'Authorization': 'Bearer ${SingletonStore.instance.authToken}'
                },
                fit: BoxFit.cover,
                fadeInDuration: Duration(milliseconds: 200),
              ),
            ),
          ),
        ),
      );
    } else {
      return Icon(Icons.description,
          size: thumbnailSize, color: Colors.grey[700]);
    }
  }

  @override
  Widget build(BuildContext context) {
    final filesState = Provider.of<FilesState>(context);
    final margin = 5.0;

    return Observer(
      builder: (_) => SelectableFilesItemTile(
        file: file,
        onTap: () => Navigator.pushNamed(
          context,
          FileViewerRoute.name,
          arguments: FileViewerScreenArguments(
            file: file,
            onUpdateFilesList: filesState.onGetFiles,
          ),
        ),
        isSelected: filesState.selectedFilesIds.contains(file["Id"]),
        child: ListTile(
          leading: _getThumbnail(context),
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(file["Name"], maxLines: 1, overflow: TextOverflow.ellipsis),
              SizedBox(height: 7.0),
              Row(
                children: <Widget>[
                  if (file["Published"] == true)
                    Icon(
                      Icons.link,
                      size: 14,
                      semanticLabel: "Has public link",
                      color: Colors.black45,
                    ),
                  if (file["Published"] == true) SizedBox(width: margin),
                  if (false)
                    Icon(
                      Icons.airplanemode_active,
                      size: 14,
                      semanticLabel: "Available offline",
                      color: Colors.black45,
                    ),
                  if (false) SizedBox(width: margin),
                  Text(filesize(file["Size"]),
                      style: Theme.of(context).textTheme.caption),
                  SizedBox(width: margin),
                  Text("|", style: Theme.of(context).textTheme.caption),
                  SizedBox(width: margin),
                  Text(
                      DateFormatting.formatDateFromSeconds(
                        timestamp: file["LastModified"],
                      ),
                      style: Theme.of(context).textTheme.caption),
                  SizedBox(width: margin),
                ],
              )
            ],
          ),
          trailing: IconButton(
            padding: EdgeInsets.only(left: 30.0),
            highlightColor: Colors.transparent,
            splashColor: Colors.transparent,
            icon: Icon(Icons.more_vert),
            onPressed: () => _showModalBottomSheet(context),
          ),
        ),
      ),
    );
  }
}
