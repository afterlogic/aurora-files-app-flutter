import 'package:aurorafiles/database/app_database.dart';
import 'package:flutter/material.dart';

import 'file.dart';
import 'folder.dart';

class FilesList extends StatelessWidget {
  final List<LocalFile> files;

  const FilesList({Key? key, required this.files}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final paddingBottom = MediaQuery.of(context).padding.bottom + 70;
    files.sort((a, b) =>
        a.isFolder ? -1 : a.name.toLowerCase().compareTo(b.name.toLowerCase()));

    return ListView.separated(
      padding: EdgeInsets.only(bottom: paddingBottom),
      itemCount: files.length,
      itemBuilder: (BuildContext context, int index) {
        if (files.isEmpty) {
          return const SizedBox.shrink();
        }
        final item = files[index];
        if (item.isFolder) {
          return FolderWidget(key: Key(item.guid ?? ''), folder: item);
        } else {
          return FileWidget(key: Key(item.guid ?? ''), file: item);
        }
      },
      separatorBuilder: (_, __) => const Padding(
        padding: EdgeInsets.only(left: 80.0, right: 16.0),
        child: Divider(height: 0.0),
      ),
    );
  }
}
