import 'package:core/core.dart';
import 'package:core/src/testing/shared/primitive_mother.dart';

abstract final class UpdatedAtMother {
  static UpdatedAt random() => UpdatedAt.create(PrimitiveMother.dateTime());

  static UpdatedAt afterCreation(CreatedAt createdAt) =>
      UpdatedAt.create(createdAt.value.add(_randomGap()));

  static UpdatedAt beforeCreation(CreatedAt createdAt) =>
      UpdatedAt.create(createdAt.value.subtract(_randomGap()));

  static UpdatedAt after(UpdatedAt updatedAt) =>
      UpdatedAt.create(updatedAt.value.add(_randomGap()));

  static UpdatedAt before(UpdatedAt updatedAt) =>
      UpdatedAt.create(updatedAt.value.subtract(_randomGap()));

  static Duration _randomGap() =>
      Duration(minutes: PrimitiveMother.integer(min: 1, max: 100000));
}
