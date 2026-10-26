import 'package:core/src/shared/errors/domain_error.dart';

final class InvalidUpdatedAtError extends DomainError {
  const InvalidUpdatedAtError(DateTime updatedAt, DateTime limit)
    : super('Update moment $updatedAt cannot be before $limit');
}
