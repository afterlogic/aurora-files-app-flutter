import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Future openDialog(
    BuildContext context, Widget Function(BuildContext) builder) {
  return Platform.isIOS
      ? showCupertinoDialog(
          context: context,
          builder: builder,
        )
      : showDialog(
          context: context,
          builder: builder,
        );
}
