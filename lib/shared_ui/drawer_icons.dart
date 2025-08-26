import 'package:aurorafiles/assets/asset.dart';
import 'package:aurorafiles/build_property.dart';
import 'package:aurorafiles/shared_ui/asset_svg_icon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:theme/app_color.dart';

class DrawerIcons {
  static Widget personal({Color? color}) {
    return Builder(
      builder: (context) {
        final effectiveColor = color ??
            (Theme.of(context).brightness == Brightness.dark
                ? AppColorDark.icons
                : AppColorLight.icons);

        if (BuildProperty.useCustomIcons) {
          return AssetSvgIcon(
            showSvg: true,
            svgPath: '${BuildProperty.imageDir}/drawer/personal.svg',
            iconData: MdiIcons.circleOutline,
            width: 24.0,
            height: 24.0,
            color: effectiveColor,
          );
        }

        return SvgPicture.asset(
          Asset.svg.iconStoragePersonal,
          width: 24,
          height: 24,
          color: effectiveColor,
        );
      },
    );
  }

  static Widget corporate({Color? color}) {
    return Builder(
      builder: (context) {
        final effectiveColor = color ??
            (Theme.of(context).brightness == Brightness.dark
                ? AppColorDark.icons
                : AppColorLight.icons);

        if (BuildProperty.useCustomIcons) {
          return AssetSvgIcon(
            showSvg: true,
            svgPath: '${BuildProperty.imageDir}/drawer/corporate.svg',
            iconData: MdiIcons.circleDouble,
            width: 24.0,
            height: 24.0,
            color: effectiveColor,
          );
        }

        return SvgPicture.asset(
          Asset.svg.iconStorageCorporate,
          width: 24,
          height: 24,
          color: effectiveColor,
        );
      },
    );
  }

  static Widget shared({Color? color}) {
    return Builder(
      builder: (context) {
        final effectiveColor = color ??
            (Theme.of(context).brightness == Brightness.dark
                ? AppColorDark.icons
                : AppColorLight.icons);

        if (BuildProperty.useCustomIcons) {
          return AssetSvgIcon(
            showSvg: true,
            svgPath: '${BuildProperty.imageDir}/drawer/shared.svg',
            iconData: Icons.share,
            width: 24.0,
            height: 24.0,
            color: effectiveColor,
          );
        }

        return SvgPicture.asset(
          Asset.svg.iconStorageShared,
          width: 24,
          height: 24,
          color: effectiveColor,
        );
      },
    );
  }

  static Widget encrypted({Color? color}) {
    return Builder(
      builder: (context) {
        final effectiveColor = color ??
            (Theme.of(context).brightness == Brightness.dark
                ? AppColorDark.icons
                : AppColorLight.icons);

        if (BuildProperty.useCustomIcons) {
          return AssetSvgIcon(
            showSvg: true,
            svgPath: '${BuildProperty.imageDir}/drawer/encryption.svg',
            iconData: MdiIcons.alien,
            width: 24.0,
            height: 24.0,
            color: effectiveColor,
          );
        }

        return SvgPicture.asset(
          Asset.svg.iconStorageEncrypted,
          width: 24,
          height: 24,
          color: effectiveColor,
        );
      },
    );
  }

  static Widget settings() {
    return Builder(
      builder: (context) {
        final color = Theme.of(context).brightness == Brightness.dark
            ? AppColorDark.icons
            : AppColorLight.icons;

        return AssetSvgIcon(
          showSvg: BuildProperty.useCustomIcons,
          svgPath: '${BuildProperty.imageDir}/drawer/settings.svg',
          iconData: Icons.settings,
          width: 24.0,
          height: 24.0,
          color: color,
        );
      },
    );
  }

  static Widget offlineMode() {
    return Builder(
      builder: (context) {
        final color = Theme.of(context).brightness == Brightness.dark
            ? AppColorDark.icons
            : AppColorLight.icons;

        return AssetSvgIcon(
          showSvg: BuildProperty.useCustomIcons,
          svgPath: '${BuildProperty.imageDir}/drawer/offline-mode.svg',
          iconData: Icons.airplanemode_active,
          width: 24.0,
          height: 24.0,
          color: color,
        );
      },
    );
  }

  static Widget favorite({Color? color}) {
    return Builder(
      builder: (context) {
        final effectiveColor = color ??
            (Theme.of(context).brightness == Brightness.dark
                ? AppColorDark.icons
                : AppColorLight.icons);

        return AssetSvgIcon(
          showSvg: BuildProperty.useCustomIcons,
          svgPath: '${BuildProperty.imageDir}/drawer/favorite.svg',
          iconData: Icons.favorite,
          width: 24.0,
          height: 24.0,
          color: effectiveColor,
        );
      },
    );
  }

  static Widget trash({Color? color}) {
    return Builder(
      builder: (context) {
        final effectiveColor = color ??
            (Theme.of(context).brightness == Brightness.dark
                ? AppColorDark.icons
                : AppColorLight.icons);

        return AssetSvgIcon(
          showSvg: BuildProperty.useCustomIcons,
          svgPath: '${BuildProperty.imageDir}/drawer/trash.svg',
          iconData: Icons.delete,
          width: 24.0,
          height: 24.0,
          color: effectiveColor,
        );
      },
    );
  }
}
