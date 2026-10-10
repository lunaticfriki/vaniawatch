import '../../shared/errors/domain/domain_error.dart';

class InvalidWatchImageUrlError extends DomainError {
  const InvalidWatchImageUrlError()
      : super('Watch image URL must be an absolute HTTP or HTTPS URL.');
}
