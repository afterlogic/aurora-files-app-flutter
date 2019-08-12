import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import 'files_item_tile.dart';

class SkeletonLoader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FilesItemTile(
      child: ListTile(
        leading: Shimmer.fromColors(
          baseColor: Colors.grey[300],
          highlightColor: Colors.grey[200],
          child: ClipRRect(
            borderRadius: BorderRadius.circular(5.0),
            child: Container(width: 50, height: 50, color: Colors.grey),
          ),
        ),
        title: Shimmer.fromColors(
          baseColor: Colors.grey[300],
          highlightColor: Colors.grey[200],
          child: ClipRRect(
            borderRadius: BorderRadius.circular(50.0),
            child: Container(
              width: double.infinity,
              height: 20,
              color: Colors.grey,
            ),
          ),
        ),
      ),
    );
  }
}
