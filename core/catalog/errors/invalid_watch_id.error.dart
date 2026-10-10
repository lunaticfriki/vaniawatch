import '../../shared/errors/domain/domain_error.dart';

class InvalidWatchIdError extends DomainError {
  const InvalidWatchIdError() : super('Watch ID must not be empty.');
}
