import '../../shared/errors/domain/domain_error.dart';

class InvalidUserIdError extends DomainError {
  const InvalidUserIdError() : super('User ID must not be empty.');
}
