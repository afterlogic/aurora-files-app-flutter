import 'package:aurorafiles/assets/asset.dart';
import 'package:aurorafiles/build_property.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:theme/app_color.dart';

class DrawerIcons {
  /// Иконка для Personal storage
  static Widget personal({Color? color}) {
    return Builder(
      builder: (context) {
        if (BuildProperty.useCustomIcons) {
          final effectiveColor = color ??
              (Theme.of(context).brightness == Brightness.dark
                  ? AppColorDark.icons
                  : AppColorLight.icons);
          return SvgPicture.asset(
            '${BuildProperty.imageDir}/drawer/personal.svg',
            width: 24,
            height: 24,
            color: effectiveColor,
          );
        }
        return SvgPicture.asset(
          Asset.svg.iconStoragePersonal,
          width: 24,
          height: 24,
          color: color,
        );
      },
    );
  }

  /// Иконка для Corporate storage
  static Widget corporate({Color? color}) {
    return Builder(
      builder: (context) {
        if (BuildProperty.useCustomIcons) {
          final effectiveColor = color ??
              (Theme.of(context).brightness == Brightness.dark
                  ? AppColorDark.icons
                  : AppColorLight.icons);
          return SvgPicture.asset(
            '${BuildProperty.imageDir}/drawer/corporate.svg',
            width: 24,
            height: 24,
            color: effectiveColor,
          );
        }
        return SvgPicture.asset(
          Asset.svg.iconStorageCorporate,
          width: 24,
          height: 24,
          color: color,
        );
      },
    );
  }

  /// Иконка для Shared storage
  static Widget shared({Color? color}) {
    return Builder(
      builder: (context) {
        if (BuildProperty.useCustomIcons) {
          final effectiveColor = color ??
              (Theme.of(context).brightness == Brightness.dark
                  ? AppColorDark.icons
                  : AppColorLight.icons);
          return SvgPicture.asset(
            '${BuildProperty.imageDir}/drawer/shared.svg',
            width: 24,
            height: 24,
            color: effectiveColor,
          );
        }
        return SvgPicture.asset(
          Asset.svg.iconStorageShared,
          width: 24,
          height: 24,
          color: color,
        );
      },
    );
  }

  /// Иконка для Encrypted storage (временно используем trash.svg как fallback)
  static Widget encrypted({Color? color}) {
    return Builder(
      builder: (context) {
        if (BuildProperty.useCustomIcons) {
          final effectiveColor = color ??
              (Theme.of(context).brightness == Brightness.dark
                  ? AppColorDark.icons
                  : AppColorLight.icons);
          return SvgPicture.asset(
            '${BuildProperty.imageDir}/drawer/encryption.svg',
            width: 24,
            height: 24,
            color: effectiveColor,
          );
        }
        return SvgPicture.asset(
          Asset.svg.iconStorageEncrypted,
          width: 24,
          height: 24,
          color: color,
        );
      },
    );
  }

  /// Иконка для Settings
  static Widget settings() {
    return Builder(
      builder: (context) {
        if (BuildProperty.useCustomIcons) {
          final color = Theme.of(context).brightness == Brightness.dark
              ? AppColorDark.icons
              : AppColorLight.icons;
          return SvgPicture.asset(
            '${BuildProperty.imageDir}/drawer/settings.svg',
            width: 24,
            height: 24,
            color: color,
          );
        }
        return const Icon(Icons.settings);
      },
    );
  }

  /// Иконка для Offline mode
  static Widget offlineMode() {
    return Builder(
      builder: (context) {
        if (BuildProperty.useCustomIcons) {
          final color = Theme.of(context).brightness == Brightness.dark
              ? AppColorDark.icons
              : AppColorLight.icons;
          return SvgPicture.asset(
            '${BuildProperty.imageDir}/drawer/offline-mode.svg',
            width: 24,
            height: 24,
            color: color,
          );
        }
        return const Icon(Icons.airplanemode_active);
      },
    );
  }

  /// Иконка для Favorite
  static Widget favorite({Color? color}) {
    return Builder(
      builder: (context) {
        if (BuildProperty.useCustomIcons) {
          final effectiveColor = color ??
              (Theme.of(context).brightness == Brightness.dark
                  ? AppColorDark.icons
                  : AppColorLight.icons);
          return SvgPicture.asset(
            '${BuildProperty.imageDir}/drawer/favorite.svg',
            width: 24,
            height: 24,
            color: effectiveColor,
          );
        }
        return Icon(Icons.favorite, color: color);
      },
    );
  }

  /// Иконка для Trash
  static Widget trash({Color? color}) {
    return Builder(
      builder: (context) {
        if (BuildProperty.useCustomIcons) {
          final effectiveColor = color ??
              (Theme.of(context).brightness == Brightness.dark
                  ? AppColorDark.icons
                  : AppColorLight.icons);
          return SvgPicture.asset(
            '${BuildProperty.imageDir}/drawer/trash.svg',
            width: 24,
            height: 24,
            color: effectiveColor,
          );
        }
        return Icon(Icons.delete, color: color);
      },
    );
  }
}
