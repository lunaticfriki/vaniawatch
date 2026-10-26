import 'package:core/core.dart';
import 'package:core/src/testing/shared/primitive_mother.dart';

abstract final class WatchDescriptionMother {
  static WatchDescription random() =>
      WatchDescription.create(PrimitiveMother.sentence());

  static WatchDescription empty() => WatchDescription.empty();
}
