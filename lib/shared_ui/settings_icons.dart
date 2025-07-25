import 'package:aurora_ui_kit/aurora_ui_kit.dart';
import 'package:aurorafiles/build_property.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:theme/app_color.dart';

class SettingsIcons {
  static Widget common() {
    return Builder(
      builder: (context) {
        if (BuildProperty.flatDesign) {
          final isDark = Theme.of(context).brightness == Brightness.dark;
          final color = isDark ? AppColorDark.icons : AppColorLight.icons;
          return SvgPicture.asset(
            '${BuildProperty.imageDir}/settings/menu/common.svg',
            width: 24,
            height: 24,
            color: color,
          );
        }
        return const Icon(Icons.tune);
      },
    );
  }

  static Widget encryption() {
    return Builder(
      builder: (context) {
        if (BuildProperty.flatDesign) {
          final isDark = Theme.of(context).brightness == Brightness.dark;
          final color = isDark ? AppColorDark.icons : AppColorLight.icons;
          return SvgPicture.asset(
            '${BuildProperty.imageDir}/settings/menu/encryption.svg',
            width: 24,
            height: 24,
            color: color,
          );
        }
        return const Icon(MdiIcons.alien);
      },
    );
  }

  static Widget openPGP() {
    return Builder(
      builder: (context) {
        if (BuildProperty.flatDesign) {
          final isDark = Theme.of(context).brightness == Brightness.dark;
          final color = isDark ? AppColorDark.icons : AppColorLight.icons;
          return SvgPicture.asset(
            '${BuildProperty.imageDir}/settings/menu/openPGP.svg',
            width: 24,
            height: 24,
            color: color,
          );
        }
        return const Icon(MdiIcons.key);
      },
    );
  }

  static Widget sync() {
    return Builder(
      builder: (context) {
        if (BuildProperty.flatDesign) {
          final isDark = Theme.of(context).brightness == Brightness.dark;
          final color = isDark ? AppColorDark.icons : AppColorLight.icons;
          return SvgPicture.asset(
            '${BuildProperty.imageDir}/settings/menu/sync.svg',
            width: 24,
            height: 24,
            color: color,
          );
        }
        return const Icon(Icons.storage);
      },
    );
  }

  static Widget about() {
    return Builder(
      builder: (context) {
        if (BuildProperty.flatDesign) {
          final isDark = Theme.of(context).brightness == Brightness.dark;
          final color = isDark ? AppColorDark.icons : AppColorLight.icons;
          return SvgPicture.asset(
            '${BuildProperty.imageDir}/settings/menu/about.svg',
            width: 24,
            height: 24,
            color: color,
          );
        }
        return const Icon(Icons.info_outline);
      },
    );
  }

  static Widget exit() {
    return Builder(
      builder: (context) {
        if (BuildProperty.flatDesign) {
          final isDark = Theme.of(context).brightness == Brightness.dark;
          final color = isDark ? AppColorDark.icons : AppColorLight.icons;
          return SvgPicture.asset(
            '${BuildProperty.imageDir}/settings/menu/exit.svg',
            width: 24,
            height: 24,
            color: color,
          );
        }
        return const Icon(Icons.exit_to_app);
      },
    );
  }

  // Иконки для common settings
  static Widget appTheme() {
    return Builder(
      builder: (context) {
        if (BuildProperty.flatDesign) {
          final isDark = Theme.of(context).brightness == Brightness.dark;
          final color = isDark ? AppColorDark.icons : AppColorLight.icons;
          return SvgPicture.asset(
            '${BuildProperty.imageDir}/settings/common/app-theme.svg',
            width: 24,
            height: 24,
            color: color,
          );
        }
        return const Icon(MdiIcons.themeLightDark);
      },
    );
  }

  // Иконки для common settings
  static Widget switchLanguage() {
    return Builder(
      builder: (context) {
        if (BuildProperty.flatDesign) {
          final isDark = Theme.of(context).brightness == Brightness.dark;
          final color = isDark ? AppColorDark.icons : AppColorLight.icons;
          return SvgPicture.asset(
            '${BuildProperty.imageDir}/settings/common/language.svg',
            width: 24,
            height: 24,
            color: color,
          );
        }
        return const Icon(Icons.language);
      },
    );
  }

  static Widget clearCache() {
    return Builder(
      builder: (context) {
        if (BuildProperty.flatDesign) {
          final isDark = Theme.of(context).brightness == Brightness.dark;
          final color = isDark ? AppColorDark.icons : AppColorLight.icons;
          return SvgPicture.asset(
            '${BuildProperty.imageDir}/settings/common/clear-cache.svg',
            width: 24,
            height: 24,
            color: color,
          );
        }
        return const Icon(MdiIcons.broom);
      },
    );
  }

  static Widget debug() {
    return Builder(
      builder: (context) {
        if (BuildProperty.flatDesign) {
          final isDark = Theme.of(context).brightness == Brightness.dark;
          final color = isDark ? AppColorDark.icons : AppColorLight.icons;
          return SvgPicture.asset(
            '${BuildProperty.imageDir}/settings/menu/debug.svg',
            width: 24,
            height: 24,
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
        if (BuildProperty.flatDesign) {
          final isDark = Theme.of(context).brightness == Brightness.dark;
          final color = isDark ? AppColorDark.icons : AppColorLight.icons;
          return SvgPicture.asset(
            '${BuildProperty.imageDir}/settings/common/arrow-right.svg',
            width: 24,
            height: 24,
            color: color,
          );
        }
        return const Icon(Icons.arrow_forward_ios);
      },
    );
  }
}
