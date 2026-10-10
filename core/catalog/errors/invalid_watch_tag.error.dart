import '../../shared/errors/domain/domain_error.dart';

class InvalidWatchTagError extends DomainError {
  const InvalidWatchTagError() : super('Watch tag must not be empty.');
}
