import '../../shared/errors/domain/domain_error.dart';

class InvalidEmailAddressError extends DomainError {
  const InvalidEmailAddressError()
      : super('Email address must be a valid email address.');
}
