import '../../shared/errors/domain/domain_error.dart';

class InvalidWatchModelError extends DomainError {
  const InvalidWatchModelError() : super('Watch model must not be empty.');
}
