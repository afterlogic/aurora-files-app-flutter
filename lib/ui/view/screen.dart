import 'package:aurorafiles/ui/locale/s.dart';
import 'package:flutter/widgets.dart';

mixin WithS<W extends StatefulWidget> on State<W> {
  S _s;

  S get s => _s;

  @override
  void didChangeDependencies() {
    _s = S.of(context);
    super.didChangeDependencies();
  }
}
