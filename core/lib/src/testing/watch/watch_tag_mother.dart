import 'package:core/core.dart';
import 'package:core/src/testing/shared/primitive_mother.dart';

abstract final class WatchTagMother {
  static WatchTag random() => WatchTag.create(PrimitiveMother.word());
}
