import 'package:aurorafiles/modules/files/state/files_state.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

import 'files_item_tile.dart';

class SkeletonLoader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final thumbnailSize = Provider.of<FilesState>(context).filesTileLeadingSize;

    return SelectableFilesItemTile(
      child: ListTile(
        leading: Shimmer.fromColors(
          baseColor: Theme.of(context).iconTheme.color.withOpacity(0.15),
          highlightColor: Theme.of(context).iconTheme.color.withOpacity(0.1),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(5.0),
            child: Container(
              width: thumbnailSize,
              height: thumbnailSize,
              color: Colors.grey,
            ),
          ),
        ),
        title: Shimmer.fromColors(
          baseColor: Theme.of(context).iconTheme.color.withOpacity(0.15),
          highlightColor: Theme.of(context).iconTheme.color.withOpacity(0.1),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              ClipRRect(
                borderRadius: BorderRadius.circular(50.0),
                child: Container(
                  width: double.infinity,
                  height: 14.0,
                  color: Colors.grey,
                ),
              ),
              SizedBox(height: 11.0),
              ClipRRect(
                borderRadius: BorderRadius.circular(50.0),
                child: Container(
                  width: 150.0,
                  height: 14.0,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
