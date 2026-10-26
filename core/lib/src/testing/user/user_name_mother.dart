import 'package:core/core.dart';
import 'package:core/src/testing/shared/primitive_mother.dart';

abstract final class UserNameMother {
  static UserName random() =>
      UserName.create(PrimitiveMother.word(minLength: 2, maxLength: 50));
}
