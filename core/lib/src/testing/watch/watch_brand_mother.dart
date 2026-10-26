import 'package:core/core.dart';
import 'package:core/src/testing/shared/primitive_mother.dart';

abstract final class WatchBrandMother {
  static WatchBrand random() => WatchBrand.create(
    PrimitiveMother.pick([
      'Seiko',
      'Casio',
      'Omega',
      'Rolex',
      'Tissot',
      'Citizen',
      'Hamilton',
      'Orient',
      'Longines',
      'Swatch',
    ]),
  );
}
