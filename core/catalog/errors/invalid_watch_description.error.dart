import '../../shared/errors/domain/domain_error.dart';

class InvalidWatchDescriptionError extends DomainError {
  const InvalidWatchDescriptionError()
      : super('Watch description must not be empty.');
}
