import 'package:core/core.dart';
import 'package:core/src/testing/shared/created_at_mother.dart';
import 'package:core/src/testing/shared/updated_at_mother.dart';
import 'package:core/src/testing/user/user_email_mother.dart';
import 'package:core/src/testing/user/user_id_mother.dart';
import 'package:core/src/testing/user/user_name_mother.dart';

abstract final class UserMother {
  static User random({
    UserId? id,
    UserName? name,
    UserEmail? email,
    CreatedAt? createdAt,
  }) => User.create(
    id: id ?? UserIdMother.random(),
    name: name ?? UserNameMother.random(),
    email: email ?? UserEmailMother.random(),
    createdAt: createdAt ?? CreatedAtMother.random(),
  );

  static User restored({
    UserId? id,
    UserName? name,
    UserEmail? email,
    CreatedAt? createdAt,
    UpdatedAt? updatedAt,
  }) {
    final created = createdAt ?? CreatedAtMother.random();
    return User.restore(
      id: id ?? UserIdMother.random(),
      name: name ?? UserNameMother.random(),
      email: email ?? UserEmailMother.random(),
      createdAt: created,
      updatedAt: updatedAt ?? UpdatedAtMother.afterCreation(created),
    );
  }

  static User empty() => User.empty();
}
