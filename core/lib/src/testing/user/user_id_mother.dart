import 'package:core/core.dart';
import 'package:core/src/testing/shared/primitive_mother.dart';

abstract final class UserIdMother {
  static UserId random() => UserId.create(PrimitiveMother.uuid());
}
