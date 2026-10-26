import 'package:core/src/shared/errors/domain_error.dart';

final class UserName {
  const UserName._(this.value);

  factory UserName.create(String value) {
    final trimmed = value.trim();
    if (trimmed.length < minLength || trimmed.length > maxLength) {
      throw InvalidUserNameError(value);
    }
    return UserName._(trimmed);
  }

  factory UserName.empty() => const UserName._('');

  static const int minLength = 2;
  static const int maxLength = 50;

  final String value;

  bool get isEmpty => value.isEmpty;

  @override
  bool operator ==(Object other) => other is UserName && other.value == value;

  @override
  int get hashCode => value.hashCode;

  @override
  String toString() => value;
}

final class InvalidUserNameError extends DomainError {
  const InvalidUserNameError(String value)
    : super(
        '"$value" is not a valid user name: it must have between '
        '${UserName.minLength} and ${UserName.maxLength} characters',
      );
}
