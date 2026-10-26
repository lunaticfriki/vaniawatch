import 'package:core/src/shared/errors/domain_error.dart';

final class UserEmail {
  const UserEmail._(this.value);

  factory UserEmail.create(String value) {
    final normalized = value.trim().toLowerCase();
    if (!_pattern.hasMatch(normalized)) {
      throw InvalidUserEmailError(value);
    }
    return UserEmail._(normalized);
  }

  factory UserEmail.empty() => const UserEmail._('');

  static final RegExp _pattern = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$');

  final String value;

  bool get isEmpty => value.isEmpty;

  @override
  bool operator ==(Object other) => other is UserEmail && other.value == value;

  @override
  int get hashCode => value.hashCode;

  @override
  String toString() => value;
}

final class InvalidUserEmailError extends DomainError {
  const InvalidUserEmailError(String value)
    : super('"$value" is not a valid email');
}
