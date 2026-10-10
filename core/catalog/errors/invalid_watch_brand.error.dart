import '../../shared/errors/domain/domain_error.dart';

class InvalidWatchBrandError extends DomainError {
  const InvalidWatchBrandError() : super('Watch brand must not be empty.');
}
