import 'package:aurorafiles/assets/asset.dart';
import 'package:aurorafiles/build_property.dart';
import 'package:aurorafiles/shared_ui/asset_icon.dart';
import 'package:aurorafiles/shared_ui/asset_svg_icon.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class FileOptionsIcons {
  static Widget copyMove({Color? color, bool isFolder = false}) {
    return Builder(
      builder: (context) {
        final iconColor = color ?? Theme.of(context).iconTheme.color;

        return AssetSvgIcon(
          showSvg: BuildProperty.useCustomIcons,
          svgPath: '${BuildProperty.imageDir}/file-options/copy-move.svg',
          iconData: isFolder ? MdiIcons.folderMove : MdiIcons.fileMove,
          width: 24.0,
          height: 24.0,
          color: iconColor,
        );
      },
    );
  }

  static Widget createShareableLink({Color? color}) {
    return Builder(
      builder: (context) {
        final iconColor = color ?? Theme.of(context).iconTheme.color;

        if (BuildProperty.useCustomIcons) {
          return AssetSvgIcon(
            showSvg: true,
            svgPath:
                '${BuildProperty.imageDir}/file-options/create-shareable-link.svg',
            iconData: MdiIcons.paperclip,
            width: 24.0,
            height: 24.0,
            color: iconColor,
          );
        }

        return AssetIcon(
          Asset.svg.insertLink,
          addedSize: 14,
          color: iconColor,
        );
      },
    );
  }

  static Widget shareWithTeammates({Color? color}) {
    return Builder(
      builder: (context) {
        final iconColor = color ?? Theme.of(context).iconTheme.color;

        return AssetSvgIcon(
          showSvg: BuildProperty.useCustomIcons,
          svgPath:
              '${BuildProperty.imageDir}/file-options/share-with-teammates.svg',
          iconData: Icons.share,
          width: 24.0,
          height: 24.0,
          color: iconColor,
        );
      },
    );
  }

  static Widget rename({Color? color}) {
    return Builder(
      builder: (context) {
        final iconColor = color ?? Theme.of(context).iconTheme.color;

        return AssetSvgIcon(
          showSvg: BuildProperty.useCustomIcons,
          svgPath: '${BuildProperty.imageDir}/file-options/rename.svg',
          iconData: Icons.edit,
          width: 24.0,
          height: 24.0,
          color: iconColor,
        );
      },
    );
  }

  static Widget delete({Color? color}) {
    return Builder(
      builder: (context) {
        final iconColor = color ?? Theme.of(context).iconTheme.color;

        return AssetSvgIcon(
          showSvg: BuildProperty.useCustomIcons,
          svgPath: '${BuildProperty.imageDir}/file-options/delete.svg',
          iconData: Icons.delete_outline,
          width: 24.0,
          height: 24.0,
          color: iconColor,
        );
      },
    );
  }

  static Widget share({Color? color}) {
    return Builder(
      builder: (context) {
        final iconColor = color ?? Theme.of(context).iconTheme.color;

        return AssetSvgIcon(
          showSvg: BuildProperty.useCustomIcons,
          svgPath: '${BuildProperty.imageDir}/file-options/share.svg',
          iconData: Icons.share,
          width: 24.0,
          height: 24.0,
          color: iconColor,
        );
      },
    );
  }

  static Widget offline({Color? color}) {
    return Builder(
      builder: (context) {
        final iconColor = color ?? Theme.of(context).iconTheme.color;

        return AssetSvgIcon(
          showSvg: BuildProperty.useCustomIcons,
          svgPath: '${BuildProperty.imageDir}/file-options/offline.svg',
          iconData: Icons.airplanemode_active,
          width: 24.0,
          height: 24.0,
          color: iconColor,
        );
      },
    );
  }

  static Widget menu({Color? color}) {
    return Builder(
      builder: (context) {
        final iconColor = color ?? Theme.of(context).iconTheme.color;

        return AssetSvgIcon(
          showSvg: BuildProperty.useCustomIcons,
          svgPath: '${BuildProperty.imageDir}/file-options/menu.svg',
          iconData: Icons.more_vert,
          width: 24.0,
          height: 24.0,
          color: iconColor,
        );
      },
    );
  }
}
