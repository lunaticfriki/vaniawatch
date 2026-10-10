import '../value_objects/email_address.value_object.dart';
import '../value_objects/user_id.value_object.dart';

class User {
  const User._({required this.id, required this.email});

  factory User.create({required UserId id, required EmailAddress email}) {
    return User._(id: id, email: email);
  }

  factory User.empty() {
    return User._(id: UserId.empty(), email: EmailAddress.empty());
  }

  final UserId id;
  final EmailAddress email;

  @override
  bool operator ==(Object other) => other is User && other.id == id;

  @override
  int get hashCode => id.hashCode;
}
