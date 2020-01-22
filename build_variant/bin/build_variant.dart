import 'dart:io';

import '../lib/build_variant.dart';

main(List<String> args) async {
  String variable = "build_variant.yaml";

  await buildVariant(
    Directory.current,
    variable,
  );
}
