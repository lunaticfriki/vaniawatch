import '../../shared/errors/domain/domain_error.dart';

class InvalidWatchComplicationError extends DomainError {
  const InvalidWatchComplicationError()
      : super('Watch complication must not be empty.');
}
