import 'package:core/core.dart';
import 'package:core/src/testing/shared/primitive_mother.dart';

abstract final class WatchImageUrlMother {
  static WatchImageUrl random() => WatchImageUrl.create(PrimitiveMother.url());

  static WatchImageUrl empty() => WatchImageUrl.empty();
}
