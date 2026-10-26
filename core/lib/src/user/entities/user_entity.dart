import 'package:core/src/shared/errors/invalid_updated_at_error.dart';
import 'package:core/src/shared/value_objects/created_at_value_object.dart';
import 'package:core/src/shared/value_objects/updated_at_value_object.dart';
import 'package:core/src/user/value_objects/user_email_value_object.dart';
import 'package:core/src/user/value_objects/user_id_value_object.dart';
import 'package:core/src/user/value_objects/user_name_value_object.dart';

final class User {
  User._({
    required this.id,
    required this._name,
    required this._email,
    required this.createdAt,
    required this._updatedAt,
  });

  factory User.create({
    required UserId id,
    required UserName name,
    required UserEmail email,
    required CreatedAt createdAt,
  }) => User._(
    id: id,
    name: name,
    email: email,
    createdAt: createdAt,
    updatedAt: UpdatedAt.fromCreatedAt(createdAt),
  );

  factory User.restore({
    required UserId id,
    required UserName name,
    required UserEmail email,
    required CreatedAt createdAt,
    required UpdatedAt updatedAt,
  }) {
    if (updatedAt.isBeforeCreation(createdAt)) {
      throw InvalidUpdatedAtError(updatedAt.value, createdAt.value);
    }
    return User._(
      id: id,
      name: name,
      email: email,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  factory User.empty() => User._(
    id: UserId.empty(),
    name: UserName.empty(),
    email: UserEmail.empty(),
    createdAt: CreatedAt.empty(),
    updatedAt: UpdatedAt.empty(),
  );

  final UserId id;
  final CreatedAt createdAt;
  UserName _name;
  UserEmail _email;
  UpdatedAt _updatedAt;

  UserName get name => _name;
  UserEmail get email => _email;
  UpdatedAt get updatedAt => _updatedAt;

  bool get isEmpty => id.isEmpty;

  void rename(UserName name, {required UpdatedAt at}) {
    _touch(at);
    _name = name;
  }

  void changeEmail(UserEmail email, {required UpdatedAt at}) {
    _touch(at);
    _email = email;
  }

  void _touch(UpdatedAt at) {
    if (at.isBefore(_updatedAt)) {
      throw InvalidUpdatedAtError(at.value, _updatedAt.value);
    }
    _updatedAt = at;
  }

  @override
  bool operator ==(Object other) => other is User && other.id == id;

  @override
  int get hashCode => id.hashCode;
}
