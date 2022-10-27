import 'package:uuid/uuid.dart';

class AlwaysNonEqualObject {
  @override
  bool operator ==(Object other) => false;

  @override
  int get hashCode => const Uuid().v4().hashCode;
}
