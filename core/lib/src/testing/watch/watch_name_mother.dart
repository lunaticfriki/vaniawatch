import 'package:core/core.dart';
import 'package:core/src/testing/shared/primitive_mother.dart';

abstract final class WatchNameMother {
  static WatchName random() => WatchName.create(
    PrimitiveMother.words(count: PrimitiveMother.integer(min: 1, max: 4)),
  );
}
