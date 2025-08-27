import 'package:aurora_ui_kit/aurora_ui_kit.dart';
import 'package:aurorafiles/build_property.dart';
import 'package:aurorafiles/shared_ui/asset_svg_icon.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:theme/app_color.dart';

class SettingsIcons {
  static Widget common() {
    return Builder(
      builder: (context) {
        final isDark = Theme.of(context).brightness == Brightness.dark;
        final color = isDark ? AppColorDark.icons : AppColorLight.icons;

        return AssetSvgIcon(
          showSvg: BuildProperty.useCustomIcons,
          svgPath: '${BuildProperty.imageDir}/settings/menu/common.svg',
          iconData: Icons.tune,
          width: 24.0,
          height: 24.0,
          color: color,
        );
      },
    );
  }

  static Widget encryption() {
    return Builder(
      builder: (context) {
        final isDark = Theme.of(context).brightness == Brightness.dark;
        final color = isDark ? AppColorDark.icons : AppColorLight.icons;

        return AssetSvgIcon(
          showSvg: BuildProperty.useCustomIcons,
          svgPath: '${BuildProperty.imageDir}/settings/menu/encryption.svg',
          iconData: MdiIcons.keyVariant,
          width: 24.0,
          height: 24.0,
          color: color,
        );
      },
    );
  }

  static Widget openPGP() {
    return Builder(
      builder: (context) {
        final isDark = Theme.of(context).brightness == Brightness.dark;
        final color = isDark ? AppColorDark.icons : AppColorLight.icons;

        return AssetSvgIcon(
          showSvg: BuildProperty.useCustomIcons,
          svgPath: '${BuildProperty.imageDir}/settings/menu/openPGP.svg',
          iconData: MdiIcons.key,
          width: 24.0,
          height: 24.0,
          color: color,
        );
      },
    );
  }

  static Widget sync() {
    return Builder(
      builder: (context) {
        final isDark = Theme.of(context).brightness == Brightness.dark;
        final color = isDark ? AppColorDark.icons : AppColorLight.icons;

        return AssetSvgIcon(
          showSvg: BuildProperty.useCustomIcons,
          svgPath: '${BuildProperty.imageDir}/settings/menu/sync.svg',
          iconData: Icons.storage,
          width: 24.0,
          height: 24.0,
          color: color,
        );
      },
    );
  }

  static Widget about() {
    return Builder(
      builder: (context) {
        final isDark = Theme.of(context).brightness == Brightness.dark;
        final color = isDark ? AppColorDark.icons : AppColorLight.icons;

        return AssetSvgIcon(
          showSvg: BuildProperty.useCustomIcons,
          svgPath: '${BuildProperty.imageDir}/settings/menu/about.svg',
          iconData: Icons.info_outline,
          width: 24.0,
          height: 24.0,
          color: color,
        );
      },
    );
  }

  static Widget exit() {
    return Builder(
      builder: (context) {
        final isDark = Theme.of(context).brightness == Brightness.dark;
        final color = isDark ? AppColorDark.icons : AppColorLight.icons;

        return AssetSvgIcon(
          showSvg: BuildProperty.useCustomIcons,
          svgPath: '${BuildProperty.imageDir}/settings/menu/exit.svg',
          iconData: Icons.exit_to_app,
          width: 24.0,
          height: 24.0,
          color: color,
        );
      },
    );
  }

  // Icons for common settings
  static Widget appTheme() {
    return Builder(
      builder: (context) {
        final isDark = Theme.of(context).brightness == Brightness.dark;
        final color = isDark ? AppColorDark.icons : AppColorLight.icons;

        return AssetSvgIcon(
          showSvg: BuildProperty.useCustomIcons,
          svgPath: '${BuildProperty.imageDir}/settings/common/app-theme.svg',
          iconData: MdiIcons.themeLightDark,
          width: 24.0,
          height: 24.0,
          color: color,
        );
      },
    );
  }

  // Icons for common settings
  static Widget switchLanguage() {
    return Builder(
      builder: (context) {
        final isDark = Theme.of(context).brightness == Brightness.dark;
        final color = isDark ? AppColorDark.icons : AppColorLight.icons;

        return AssetSvgIcon(
          showSvg: BuildProperty.useCustomIcons,
          svgPath: '${BuildProperty.imageDir}/settings/common/language.svg',
          iconData: Icons.language,
          width: 24.0,
          height: 24.0,
          color: color,
        );
      },
    );
  }

  static Widget clearCache() {
    return Builder(
      builder: (context) {
        final isDark = Theme.of(context).brightness == Brightness.dark;
        final color = isDark ? AppColorDark.icons : AppColorLight.icons;

        return AssetSvgIcon(
          showSvg: BuildProperty.useCustomIcons,
          svgPath: '${BuildProperty.imageDir}/settings/common/clear-cache.svg',
          iconData: MdiIcons.broom,
          width: 24.0,
          height: 24.0,
          color: color,
        );
      },
    );
  }

  static Widget debug() {
    return Builder(
      builder: (context) {
        final isDark = Theme.of(context).brightness == Brightness.dark;
        final color = isDark ? AppColorDark.icons : AppColorLight.icons;

        if (BuildProperty.useCustomIcons) {
          return AssetSvgIcon(
            showSvg: true,
            svgPath: '${BuildProperty.imageDir}/settings/menu/debug.svg',
            iconData: Icons.perm_device_information,
            width: 24.0,
            height: 24.0,
            color: color,
          );
        }

        return const AMCircleIcon(Icons.perm_device_information);
      },
    );
  }

  static Widget arrowRight() {
    return Builder(
      builder: (context) {
        final isDark = Theme.of(context).brightness == Brightness.dark;
        final color = isDark ? AppColorDark.icons : AppColorLight.icons;

        return AssetSvgIcon(
          showSvg: BuildProperty.useCustomIcons,
          svgPath: '${BuildProperty.imageDir}/settings/common/arrow-right.svg',
          iconData: Icons.arrow_forward_ios,
          width: 24.0,
          height: 24.0,
          color: color,
        );
      },
    );
  }

  static Widget deleteAccount() {
    return Builder(
      builder: (context) {
        final isDark = Theme.of(context).brightness == Brightness.dark;
        final color = isDark ? AppColorDark.icons : AppColorLight.icons;

        return AssetSvgIcon(
          showSvg: BuildProperty.useCustomIcons,
          svgPath: '${BuildProperty.imageDir}/settings/menu/delete-account.svg',
          iconData: Icons.delete_outline,
          width: 24.0,
          height: 24.0,
          color: color,
        );
      },
    );
  }
}
