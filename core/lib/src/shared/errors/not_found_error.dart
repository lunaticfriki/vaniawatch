import 'package:core/src/shared/errors/domain_error.dart';

abstract class NotFoundError extends DomainError {
  const NotFoundError(super.message);
}
