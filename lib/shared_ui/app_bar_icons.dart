import 'package:aurorafiles/assets/asset.dart';
import 'package:aurorafiles/build_property.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import 'asset_icon.dart';

/// Утилитный класс для работы с иконками AppBar
/// Использует кастомные SVG иконки для плоского дизайна (flatDesign)
class AppBarIcons {
  static String get _basePath => '${BuildProperty.imageDir}/m-app-bar/';

  /// Иконка "Бургер" (используется в качестве меню)
  static Widget burger() {
    return Builder(
      builder: (context) {
        if (BuildProperty.flatDesign) {
          return SvgPicture.asset(
            '${_basePath}burger.svg',
            width: 18,
            height: 14,
            color: Theme.of(context).iconTheme.color,
          );
        }
        return const Icon(Icons.arrow_back_ios);
      },
    );
  }

  /// Иконка "Назад"
  static Widget back() {
    return Builder(
      builder: (context) {
        if (BuildProperty.flatDesign) {
          return SvgPicture.asset(
            '${_basePath}back.svg',
            width: 18,
            height: 14,
            color: Theme.of(context).iconTheme.color,
          );
        }
        return const Icon(Icons.arrow_back_ios);
      },
    );
  }

  /// Иконка "Поиск"
  static Widget search() {
    return Builder(
      builder: (context) {
        if (BuildProperty.flatDesign) {
          return SvgPicture.asset(
            '${_basePath}search.svg',
            width: 20,
            height: 20,
            color: Theme.of(context).iconTheme.color,
          );
        }
        return const Icon(Icons.search);
      },
    );
  }

  /// Иконка "Закрыть"
  static Widget close() {
    return Builder(
      builder: (context) {
        if (BuildProperty.flatDesign) {
          return SvgPicture.asset(
            '${_basePath}close.svg',
            width: 24,
            height: 24,
            color: Theme.of(context).iconTheme.color,
          );
        }
        return const Icon(Icons.close);
      },
    );
  }

  /// Иконка "Очистить" (используется как close для compatibility)
  static Widget clear() {
    return Builder(
      builder: (context) {
        if (BuildProperty.flatDesign) {
          return SvgPicture.asset(
            '${_basePath}close.svg',
            width: 24,
            height: 24,
            color: Theme.of(context).iconTheme.color,
          );
        }
        return const Icon(Icons.clear);
      },
    );
  }

  /// Иконка "Меню" (burger)
  static Widget menu() {
    return Builder(
      builder: (context) {
        if (BuildProperty.flatDesign) {
          return SvgPicture.asset(
            '${_basePath}burger.svg',
            width: 18,
            height: 14,
            color: Theme.of(context).iconTheme.color,
          );
        }
        return const Icon(Icons.menu);
      },
    );
  }

  /// Иконка "Информация"
  static Widget info() {
    return Builder(
      builder: (context) {
        if (BuildProperty.flatDesign) {
          return SvgPicture.asset(
            '${_basePath}info.svg',
            width: 24,
            height: 24,
            color: Theme.of(context).iconTheme.color,
          );
        }
        return const Icon(Icons.info_outline);
      },
    );
  }

  static Widget link() {
    return Builder(
      builder: (context) {
        if (BuildProperty.flatDesign) {
          return SvgPicture.asset(
            '${_basePath}link.svg',
            width: 24,
            height: 24,
            color: Theme.of(context).iconTheme.color,
          );
        }
        return AssetIcon(
          Asset.svg.insertLink,
          addedSize: 14,
        );
      },
    );
  }

  static Widget delete() {
    return Builder(
      builder: (context) {
        if (BuildProperty.flatDesign) {
          return SvgPicture.asset(
            '${_basePath}delete.svg',
            width: 24,
            height: 24,
            color: Theme.of(context).iconTheme.color,
          );
        }
        return const Icon(Icons.delete_outline);
      },
    );
  }

  static Widget other() {
    return Builder(
      builder: (context) {
        if (BuildProperty.flatDesign) {
          return SvgPicture.asset(
            '${_basePath}other.svg',
            width: 24,
            height: 24,
            color: Theme.of(context).iconTheme.color,
          );
        }
        return const Icon(Icons.more_vert);
      },
    );
  }

  static Widget share() {
    return Builder(
      builder: (context) {
        if (BuildProperty.flatDesign) {
          return SvgPicture.asset(
            '${_basePath}share.svg',
            width: 24,
            height: 24,
            color: Theme.of(context).iconTheme.color,
          );
        }
        return const Icon(Icons.share);
      },
    );
  }

  static Widget shareWithTeammates() {
    return Builder(
      builder: (context) {
        if (BuildProperty.flatDesign) {
          return SvgPicture.asset(
            '${_basePath}share-with-teammates.svg',
            width: 24,
            height: 24,
            color: Theme.of(context).iconTheme.color,
          );
        }
        return const Icon(Icons.share);
      },
    );
  }

  static Widget copyMove() {
    return Builder(
      builder: (context) {
        if (BuildProperty.flatDesign) {
          return SvgPicture.asset(
            '${_basePath}copy-move.svg',
            width: 24,
            height: 24,
            color: Theme.of(context).iconTheme.color,
          );
        }
        return const Icon(MdiIcons.fileMove);
      },
    );
  }

  static Widget moveToFolder() {
    return Builder(
      builder: (context) {
        if (BuildProperty.flatDesign) {
          return SvgPicture.asset(
            '${_basePath}move-to-folder.svg',
            width: 24,
            height: 24,
            color: Theme.of(context).iconTheme.color,
          );
        }
        return const Icon(MdiIcons.fileMove);
      },
    );
  }

  static Widget rename() {
    return Builder(
      builder: (context) {
        if (BuildProperty.flatDesign) {
          return SvgPicture.asset(
            '${_basePath}rename.svg',
            width: 24,
            height: 24,
            color: Theme.of(context).iconTheme.color,
          );
        }
        return const Icon(Icons.edit);
      },
    );
  }

  /// Иконка "Папка"
  static Widget folder() {
    return Builder(
      builder: (context) {
        if (BuildProperty.flatDesign) {
          return SvgPicture.asset(
            '${_basePath}folder.svg',
            width: 24,
            height: 24,
            color: Theme.of(context).iconTheme.color,
          );
        }
        return const Icon(Icons.folder);
      },
    );
  }

  /// Иконка "Personal"
  static Widget personal() {
    return Builder(
      builder: (context) {
        if (BuildProperty.flatDesign) {
          return SvgPicture.asset(
            '${_basePath}personal.svg',
            width: 24,
            height: 24,
            color: Theme.of(context).iconTheme.color,
          );
        }
        return const Icon(Icons.person);
      },
    );
  }
}
