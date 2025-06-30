import 'package:aurorafiles/build_property.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// Утилитный класс для работы с иконками AppBar
/// Использует кастомные SVG иконки для плоского дизайна (flatDesign)
class AppBarIcons {
  static String get _basePath => '${BuildProperty.imageDir}/m-app-bar/';

  /// Иконка "Назад"
  static Widget back({Color? color}) {
    if (BuildProperty.flatDesign) {
      return SvgPicture.asset(
        '${_basePath}back.svg',
        width: 18,
        height: 14,
        color: color,
      );
    }
    return Icon(Icons.arrow_back_ios, color: color);
  }

  /// Иконка "Поиск"
  static Widget search({Color? color}) {
    if (BuildProperty.flatDesign) {
      return SvgPicture.asset(
        '${_basePath}search.svg',
        width: 20,
        height: 20,
        color: color,
      );
    }
    return Icon(Icons.search, color: color);
  }

  /// Иконка "Закрыть"
  static Widget close({Color? color}) {
    if (BuildProperty.flatDesign) {
      return SvgPicture.asset(
        '${_basePath}close.svg',
        width: 24,
        height: 24,
        color: color,
      );
    }
    return Icon(Icons.close, color: color);
  }

  /// Иконка "Очистить" (используется как close для compatibility)
  static Widget clear({Color? color}) {
    if (BuildProperty.flatDesign) {
      return SvgPicture.asset(
        '${_basePath}close.svg',
        width: 24,
        height: 24,
        color: color,
      );
    }
    return Icon(Icons.clear, color: color);
  }

  /// Иконка "Меню" (burger)
  static Widget menu({Color? color}) {
    if (BuildProperty.flatDesign) {
      return SvgPicture.asset(
        '${_basePath}burger.svg',
        width: 18,
        height: 14,
        color: color,
      );
    }
    return Icon(Icons.menu, color: color);
  }

  /// Иконка "Информация"
  static Widget info({Color? color}) {
    if (BuildProperty.flatDesign) {
      return SvgPicture.asset(
        '${_basePath}info.svg',
        width: 24,
        height: 24,
        color: color,
      );
    }
    return Icon(Icons.info_outline, color: color);
  }
}
