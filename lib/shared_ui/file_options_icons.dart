import 'package:aurorafiles/assets/asset.dart';
import 'package:aurorafiles/build_property.dart';
import 'package:aurorafiles/shared_ui/asset_icon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:theme/app_color.dart';

class FileOptionsIcons {
  static Widget copyMove({Color? color, bool isFolder = false}) {
    return Builder(
      builder: (context) {
        // Проверяем, есть ли кастомная иконка для текущей темы
        const customIconPath =
            '${BuildProperty.imageDir}/file-options/copy-move.svg';

        try {
          final isDark = Theme.of(context).brightness == Brightness.dark;
          final customColor = isDark ? AppColorDark.icons : AppColorLight.icons;
          return SvgPicture.asset(
            customIconPath,
            width: 24,
            height: 24,
            color: customColor,
          );
        } catch (e) {
          // Если кастомной иконки нет, используем стандартную
          return Icon(
            isFolder ? MdiIcons.folderMove : MdiIcons.fileMove,
            color: color,
          );
        }
      },
    );
  }

  static Widget createShareableLink({Color? color}) {
    return Builder(
      builder: (context) {
        const customIconPath =
            '${BuildProperty.imageDir}/file-options/create-shareable-link.svg';

        try {
          final isDark = Theme.of(context).brightness == Brightness.dark;
          final customColor = isDark ? AppColorDark.icons : AppColorLight.icons;
          return SvgPicture.asset(
            customIconPath,
            width: 24,
            height: 24,
            color: customColor,
          );
        } catch (e) {
          return AssetIcon(
            Asset.svg.insertLink,
            addedSize: 14,
            color: color,
          );
        }
      },
    );
  }

  static Widget shareWithTeammates({Color? color}) {
    return Builder(
      builder: (context) {
        const customIconPath =
            '${BuildProperty.imageDir}/file-options/share-with-teammates.svg';

        try {
          final isDark = Theme.of(context).brightness == Brightness.dark;
          final customColor = isDark ? AppColorDark.icons : AppColorLight.icons;
          return SvgPicture.asset(
            customIconPath,
            width: 24,
            height: 24,
            color: customColor,
          );
        } catch (e) {
          return Icon(
            Icons.share,
            color: color,
          );
        }
      },
    );
  }

  static Widget rename({Color? color}) {
    return Builder(
      builder: (context) {
        const customIconPath =
            '${BuildProperty.imageDir}/file-options/rename.svg';

        try {
          final isDark = Theme.of(context).brightness == Brightness.dark;
          final customColor = isDark ? AppColorDark.icons : AppColorLight.icons;
          return SvgPicture.asset(
            customIconPath,
            width: 24,
            height: 24,
            color: customColor,
          );
        } catch (e) {
          return Icon(
            Icons.edit,
            color: color,
          );
        }
      },
    );
  }

  static Widget delete({Color? color}) {
    return Builder(
      builder: (context) {
        const customIconPath =
            '${BuildProperty.imageDir}/file-options/delete.svg';

        try {
          final isDark = Theme.of(context).brightness == Brightness.dark;
          final customColor = isDark ? AppColorDark.icons : AppColorLight.icons;
          return SvgPicture.asset(
            customIconPath,
            width: 24,
            height: 24,
            color: customColor,
          );
        } catch (e) {
          return Icon(
            Icons.delete_outline,
            color: color,
          );
        }
      },
    );
  }

  static Widget share({Color? color}) {
    return Builder(
      builder: (context) {
        const customIconPath =
            '${BuildProperty.imageDir}/file-options/share.svg';

        try {
          final isDark = Theme.of(context).brightness == Brightness.dark;
          final customColor = isDark ? AppColorDark.icons : AppColorLight.icons;
          return SvgPicture.asset(
            customIconPath,
            width: 24,
            height: 24,
            color: customColor,
          );
        } catch (e) {
          return Icon(
            Icons.share,
            color: color,
          );
        }
      },
    );
  }

  static Widget offline({Color? color}) {
    return Builder(
      builder: (context) {
        const customIconPath =
            '${BuildProperty.imageDir}/file-options/offline.svg';

        try {
          final isDark = Theme.of(context).brightness == Brightness.dark;
          final customColor = isDark ? AppColorDark.icons : AppColorLight.icons;
          return SvgPicture.asset(
            customIconPath,
            width: 24,
            height: 24,
            color: customColor,
          );
        } catch (e) {
          return Icon(
            Icons.offline_pin,
            color: color,
          );
        }
      },
    );
  }
}
