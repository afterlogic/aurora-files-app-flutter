import 'dart:io';

import 'package:aurorafiles/modules/app_store.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Future openDialog(BuildContext context, Widget Function(BuildContext) builder) {
  final cupertinoTheme =CupertinoTheme.of(context);
  return Platform.isIOS
      ? showCupertinoDialog(
          context: context,
          builder: (context) => Material(
            type: MaterialType.transparency,
            child: Theme(
              data: ThemeData(
                brightness: Brightness.light
              ),
              child: CupertinoTheme(
                data: cupertinoTheme.copyWith(
                  brightness: Brightness.light
                ),
                child: builder(context),
              ),
            ),
          ),
        )
      : showDialog(
          context: context,
          builder: builder,
        );
}
