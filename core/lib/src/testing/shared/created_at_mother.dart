import 'package:core/core.dart';
import 'package:core/src/testing/shared/primitive_mother.dart';

abstract final class CreatedAtMother {
  static CreatedAt random() => CreatedAt.create(PrimitiveMother.dateTime());
}
