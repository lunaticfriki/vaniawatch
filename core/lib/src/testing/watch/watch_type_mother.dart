import 'package:core/core.dart';
import 'package:core/src/testing/shared/primitive_mother.dart';

abstract final class WatchTypeMother {
  static WatchType random() => PrimitiveMother.pick([
    WatchType.analog(),
    WatchType.digital(),
    WatchType.anaDigi(),
  ]);
}
