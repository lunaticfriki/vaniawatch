import 'package:core/core.dart';
import 'package:core/src/testing/shared/primitive_mother.dart';

abstract final class WatchIdMother {
  static WatchId random() => WatchId.create(PrimitiveMother.uuid());
}
