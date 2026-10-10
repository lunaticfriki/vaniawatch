import '../../../auth/entities/user.entity.dart';
import '../../value_objects/__tests__/email_address.mother.dart';
import '../../value_objects/__tests__/user_id.mother.dart';

class UserMother {
  static User empty() => User.empty();

  static User valid() {
    return User.create(
      id: UserIdMother.valid(),
      email: EmailAddressMother.valid(),
    );
  }
}
