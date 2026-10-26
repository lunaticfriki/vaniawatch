import 'package:core/src/shared/errors/domain_error.dart';
import 'package:core/src/shared/services/uuid_service.dart';

final class UserId {
  const UserId._(this.value);

  factory UserId.create(String value) {
    final normalized = value.trim().toLowerCase();
    if (!UuidService.isValid(normalized)) {
      throw InvalidUserIdError(value);
    }
    return UserId._(normalized);
  }

  factory UserId.generate() => UserId._(UuidService.generate());

  factory UserId.empty() => const UserId._('');

  final String value;

  bool get isEmpty => value.isEmpty;

  @override
  bool operator ==(Object other) => other is UserId && other.value == value;

  @override
  int get hashCode => value.hashCode;

  @override
  String toString() => value;
}

final class InvalidUserIdError extends DomainError {
  const InvalidUserIdError(String value)
    : super('"$value" is not a valid user id');
}
