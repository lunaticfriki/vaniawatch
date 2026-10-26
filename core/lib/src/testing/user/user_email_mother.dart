import 'package:core/core.dart';
import 'package:core/src/testing/shared/primitive_mother.dart';

abstract final class UserEmailMother {
  static UserEmail random() => UserEmail.create(PrimitiveMother.email());
}
