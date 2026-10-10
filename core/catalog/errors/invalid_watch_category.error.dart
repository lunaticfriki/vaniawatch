import '../../shared/errors/domain/domain_error.dart';

class InvalidWatchCategoryError extends DomainError {
  const InvalidWatchCategoryError()
      : super('Watch category must not be empty.');
}
