import 'package:aurorafiles/assets/asset.dart';
import 'package:aurorafiles/models/file_group.dart';
import 'package:aurorafiles/modules/app_store.dart';
import 'package:aurorafiles/modules/files/components/file.dart';
import 'package:aurorafiles/modules/files/components/folder.dart';
import 'package:aurorafiles/utils/file_utils.dart';
import 'package:aurorafiles/utils/text_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:theme/app_theme.dart';

class FoundedFilesList extends StatelessWidget {
  final List<FileGroup> fileGroups;

  const FoundedFilesList({Key? key, required this.fileGroups})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final paddingBottom = MediaQuery.of(context).padding.bottom + 70;

    return ListView.builder(
      padding: EdgeInsets.only(bottom: paddingBottom),
      itemCount: fileGroups.length,
      itemBuilder: (_, index) {
        return _FileGroupWidget(fileGroups[index]);
      },
    );
  }
}

class _FileGroupWidget extends StatelessWidget {
  final FileGroup group;

  const _FileGroupWidget(this.group, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Visibility(
          visible: group.path.isNotEmpty,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(28, 16, 24, 8),
            child: Row(
              children: [
                SvgPicture.asset(
                  Asset.svg.iconFolder,
                  width: 24,
                  height: 24,
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _CroppedFilePath(group.path),
                ),
              ],
            ),
          ),
        ),
        Column(
          mainAxisSize: MainAxisSize.min,
          children: List<Widget>.generate(
            group.files.length,
            (index) {
              final item = group.files[index];
              return Container(
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(color: theme.dividerColor, width: 0.0),
                  ),
                ),
                child: item.isFolder
                    ? FolderWidget(key: Key(item.guid ?? ''), folder: item)
                    : FileWidget(key: Key(item.guid ?? ''), file: item),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _CroppedFilePath extends StatelessWidget {
  final String path;

  const _CroppedFilePath(this.path, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const pathDelimiter = '/';
    const pathDelimiterReplace = ' / ';

    final isDark = AppStore.settingsState.isDarkTheme ?? false;
    final textStyle = AppTheme.subtitle1NewTextStyle(isDark).copyWith(
      height: 1.5,
    );

    return LayoutBuilder(
      builder: (context, size) {
        var croppedPath = path;
        // var croppedPath = '/folder_1/folder_2/folder_3/folder_4/folder_5/folder_6/folder_7';
        // var croppedPath = '/folder_1/...folder_2/folder_3/folder_4/folder_5/folder_6/folder_7';
        // var croppedPath = '/long_long_long_long_long_long_long_long_folder_name/';
        // var croppedPath = '/long_long_long_long_long_long_long_long_folder_name';
        // var croppedPath = '/long_long_long_long_long_long_long_long_folder_name...';
        // var croppedPath = 'long_long_long_long_long_long_long_long_folder_name/...';
        // var croppedPath = '/long_long_long_long_long_long_long_long_folder_name/folder_2';
        // var croppedPath = '/folder_1/long_long_long_long_long_long_long_long_folder_name';
        // var croppedPath = '/long_long_long_long_long_long_long_long_folder_name/f2';
        // var croppedPath = '/f1/long_long_long_long_long_long_long_long_folder_name';
        // var croppedPath = 'long_long_long_long_long_long_long_long_folder_name_1/long_long_long_long_long_long_long_long_folder_name_2';
        if (croppedPath.startsWith(pathDelimiter)) {
          croppedPath = croppedPath.substring(pathDelimiter.length);
        }
        croppedPath = croppedPath.replaceAll(
          pathDelimiter,
          pathDelimiterReplace,
        );
        while (TextUtils.hasTextOverflow(croppedPath, textStyle, size)) {
          croppedPath = FileUtils.reduceFilePath(
            path: croppedPath,
            delimiterText: pathDelimiterReplace,
          );
        }

        return Text(
          croppedPath,
          style: textStyle,
          maxLines: 1,
        );
      },
    );
  }
}
