import 'package:flutter/material.dart';

class ProviderWidget<T extends Object> extends InheritedWidget {
  final T value;

  ProviderWidget({@required this.value, @required child}) : super(child: child);

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) {
    if (oldWidget is ProviderWidget<T>) {
      return oldWidget.value != value;
    }
    return true;
  }

  static T of<T extends Object>(BuildContext context) =>
      (context.inheritFromWidgetOfExactType(_typeOf<ProviderWidget<T>>())
              as ProviderWidget<T>)
          .value;
}

Type _typeOf<T>() => T;
