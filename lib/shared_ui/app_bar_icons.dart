import 'package:aurorafiles/assets/asset.dart';
import 'package:aurorafiles/build_property.dart';
import 'package:aurorafiles/shared_ui/asset_svg_icon.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import 'asset_icon.dart';

class AppBarIcons {
  static String get _basePath => '${BuildProperty.imageDir}/m-app-bar/';

  static Widget burger() {
    return Builder(
      builder: (context) {
        final iconColor = Theme.of(context).iconTheme.color;

        return AssetSvgIcon(
          showSvg: BuildProperty.useCustomIcons,
          svgPath: '${_basePath}burger.svg',
          iconData: Icons.menu,
          width: 18.0,
          height: 14.0,
          color: iconColor,
        );
      },
    );
  }

  static Widget back() {
    return Builder(
      builder: (context) {
        final iconColor = Theme.of(context).iconTheme.color;

        return AssetSvgIcon(
          showSvg: BuildProperty.useCustomIcons,
          svgPath: '${_basePath}back.svg',
          iconData: Icons.arrow_back_ios,
          width: 18.0,
          height: 14.0,
          color: iconColor,
        );
      },
    );
  }

  static Widget search() {
    return Builder(
      builder: (context) {
        final iconColor = Theme.of(context).iconTheme.color;

        return AssetSvgIcon(
          showSvg: BuildProperty.useCustomIcons,
          svgPath: '${_basePath}search.svg',
          iconData: Icons.search,
          width: 20.0,
          height: 20.0,
          color: iconColor,
        );
      },
    );
  }

  static Widget close() {
    return Builder(
      builder: (context) {
        final iconColor = Theme.of(context).iconTheme.color;

        return AssetSvgIcon(
          showSvg: BuildProperty.useCustomIcons,
          svgPath: '${_basePath}close.svg',
          iconData: Icons.close,
          width: 24.0,
          height: 24.0,
          color: iconColor,
        );
      },
    );
  }

  static Widget clear() {
    return Builder(
      builder: (context) {
        final iconColor = Theme.of(context).iconTheme.color;

        return AssetSvgIcon(
          showSvg: BuildProperty.useCustomIcons,
          svgPath: '${_basePath}close.svg',
          iconData: Icons.clear,
          width: 24.0,
          height: 24.0,
          color: iconColor,
        );
      },
    );
  }

  static Widget menu() {
    return Builder(
      builder: (context) {
        final iconColor = Theme.of(context).iconTheme.color;

        return AssetSvgIcon(
          showSvg: BuildProperty.useCustomIcons,
          svgPath: '${_basePath}burger.svg',
          iconData: Icons.menu,
          width: 18.0,
          height: 14.0,
          color: iconColor,
        );
      },
    );
  }

  static Widget info() {
    return Builder(
      builder: (context) {
        final iconColor = Theme.of(context).iconTheme.color;

        return AssetSvgIcon(
          showSvg: BuildProperty.useCustomIcons,
          svgPath: '${_basePath}info.svg',
          iconData: Icons.info_outline,
          width: 24.0,
          height: 24.0,
          color: iconColor,
        );
      },
    );
  }

  static Widget link() {
    return Builder(
      builder: (context) {
        final iconColor = Theme.of(context).iconTheme.color;

        if (BuildProperty.useCustomIcons) {
          return AssetSvgIcon(
            showSvg: true,
            svgPath: '${_basePath}link.svg',
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

  static Widget delete() {
    return Builder(
      builder: (context) {
        final iconColor = Theme.of(context).iconTheme.color;

        return AssetSvgIcon(
          showSvg: BuildProperty.useCustomIcons,
          svgPath: '${_basePath}delete.svg',
          iconData: Icons.delete_outline,
          width: 24.0,
          height: 24.0,
          color: iconColor,
        );
      },
    );
  }

  static Widget other() {
    return Builder(
      builder: (context) {
        final iconColor = Theme.of(context).iconTheme.color;

        return AssetSvgIcon(
          showSvg: BuildProperty.useCustomIcons,
          svgPath: '${_basePath}other.svg',
          iconData: Icons.more_vert,
          width: 24.0,
          height: 24.0,
          color: iconColor,
        );
      },
    );
  }

  static Widget share() {
    return Builder(
      builder: (context) {
        final iconColor = Theme.of(context).iconTheme.color;

        return AssetSvgIcon(
          showSvg: BuildProperty.useCustomIcons,
          svgPath: '${_basePath}share.svg',
          iconData: Icons.share,
          width: 24.0,
          height: 24.0,
          color: iconColor,
        );
      },
    );
  }

  static Widget shareWithTeammates() {
    return Builder(
      builder: (context) {
        final iconColor = Theme.of(context).iconTheme.color;

        return AssetSvgIcon(
          showSvg: BuildProperty.useCustomIcons,
          svgPath: '${_basePath}share-with-teammates.svg',
          iconData: Icons.share,
          width: 24.0,
          height: 24.0,
          color: iconColor,
        );
      },
    );
  }

  static Widget copyMove() {
    return Builder(
      builder: (context) {
        final iconColor = Theme.of(context).iconTheme.color;

        return AssetSvgIcon(
          showSvg: BuildProperty.useCustomIcons,
          svgPath: '${_basePath}copy-move.svg',
          iconData: MdiIcons.fileMove,
          width: 24.0,
          height: 24.0,
          color: iconColor,
        );
      },
    );
  }

  static Widget moveToFolder() {
    return Builder(
      builder: (context) {
        final iconColor = Theme.of(context).iconTheme.color;

        return AssetSvgIcon(
          showSvg: BuildProperty.useCustomIcons,
          svgPath: '${_basePath}move-to-folder.svg',
          iconData: MdiIcons.fileMove,
          width: 24.0,
          height: 24.0,
          color: iconColor,
        );
      },
    );
  }

  static Widget rename() {
    return Builder(
      builder: (context) {
        final iconColor = Theme.of(context).iconTheme.color;

        return AssetSvgIcon(
          showSvg: BuildProperty.useCustomIcons,
          svgPath: '${_basePath}rename.svg',
          iconData: Icons.edit,
          width: 24.0,
          height: 24.0,
          color: iconColor,
        );
      },
    );
  }

  static Widget folder() {
    return Builder(
      builder: (context) {
        final iconColor = Theme.of(context).iconTheme.color;

        return AssetSvgIcon(
          showSvg: BuildProperty.useCustomIcons,
          svgPath: '${_basePath}folder.svg',
          iconData: Icons.folder,
          width: 24.0,
          height: 24.0,
          color: iconColor,
        );
      },
    );
  }

  static Widget addFolder() {
    return Builder(
      builder: (context) {
        final iconColor = Theme.of(context).iconTheme.color;

        return AssetSvgIcon(
          showSvg: BuildProperty.useCustomIcons,
          svgPath: '${_basePath}add-folder.svg',
          iconData: Icons.create_new_folder,
          width: 24.0,
          height: 24.0,
          color: iconColor,
        );
      },
    );
  }

  static Widget storage() {
    return Builder(
      builder: (context) {
        final iconColor = Theme.of(context).iconTheme.color;

        return AssetSvgIcon(
          showSvg: BuildProperty.useCustomIcons,
          svgPath: '${_basePath}storage.svg',
          iconData: Icons.storage,
          width: 24.0,
          height: 24.0,
          color: iconColor,
        );
      },
    );
  }

  static Widget personal() {
    return Builder(
      builder: (context) {
        final iconColor = Theme.of(context).iconTheme.color;

        return AssetSvgIcon(
          showSvg: BuildProperty.useCustomIcons,
          svgPath: '${_basePath}personal.svg',
          iconData: Icons.person,
          width: 24.0,
          height: 24.0,
          color: iconColor,
        );
      },
    );
  }
}
