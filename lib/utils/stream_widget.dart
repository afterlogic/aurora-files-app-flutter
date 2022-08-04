import 'package:flutter/widgets.dart';

class StreamWidget<T> extends StreamBuilder {
  StreamWidget(
    Stream<T> stream,
    Widget Function(BuildContext, T) onBuild, {
    T? initialData,
  }) : super(
          initialData: initialData,
          builder: (context, snapshot) => onBuild(context, snapshot.data),
          stream: stream,
        );
}
