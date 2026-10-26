import 'package:core/core.dart';
import 'package:core/src/testing/shared/primitive_mother.dart';

abstract final class WatchCategoryMother {
  static WatchCategory random() => PrimitiveMother.pick([
    WatchCategory.mechanical(),
    WatchCategory.quartz(),
  ]);
}
