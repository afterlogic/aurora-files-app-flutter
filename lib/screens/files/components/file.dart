import 'package:aurorafiles/screens/file_viewer/file_viewer_route.dart';
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
                image: AssetImage("lib/assets/images/image_placeholder.jpg")
              )
            ),
            child: Hero(
              tag: file["ThumbnailUrl"],
              child: CachedNetworkImage(
                imageUrl: '${SingletonStore.instance.hostName}/${file["ThumbnailUrl"]}',
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
          title:
              Text(file["Name"], maxLines: 2, overflow: TextOverflow.ellipsis),
          trailing: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              Text(filesize(file["Size"])),
              SizedBox(height: 4.0),
              Text(DateFormatting.formatDateFromSeconds(
                timestamp: file["LastModified"],
              )),
            ],
          ),
        ),
      ),
    );
  }
}
