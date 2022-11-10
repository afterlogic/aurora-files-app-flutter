import 'package:aurorafiles/models/file_group.dart';
import 'package:aurorafiles/modules/files/components/file.dart';
import 'package:aurorafiles/modules/files/components/folder.dart';
import 'package:flutter/material.dart';

class FoundedFilesList extends StatelessWidget {
  final List<FileGroup> fileGroups;

  const FoundedFilesList({Key? key, required this.fileGroups})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final paddingBottom = MediaQuery.of(context).padding.bottom + 70;
    return ListView.separated(
      padding: EdgeInsets.only(bottom: paddingBottom),
      itemCount: fileGroups.length,
      itemBuilder: (_, index) {
        return _FileGroupWidget(fileGroups[index]);
      },
      separatorBuilder: (_, __) {
        return const Padding(
          padding: EdgeInsets.only(left: 80.0, right: 16.0),
          child: Divider(height: 0.0),
        );
      },
    );
  }
}

class _FileGroupWidget extends StatelessWidget {
  final FileGroup group;

  const _FileGroupWidget(this.group, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(group.path),
        Column(
          mainAxisSize: MainAxisSize.min,
          children: List<Widget>.generate(
            group.files.length,
            (index) {
              final item = group.files[index];
              if (item.isFolder) {
                return FolderWidget(key: Key(item.guid ?? ''), folder: item);
              } else {
                return FileWidget(key: Key(item.guid ?? ''), file: item);
              }
            },
          ),
        ),
      ],
    );
  }
}
