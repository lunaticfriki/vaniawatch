import 'package:core/src/shared/errors/not_found_error.dart';
import 'package:core/src/watch/value_objects/watch_id_value_object.dart';

final class WatchNotFoundError extends NotFoundError {
  WatchNotFoundError(WatchId id) : super('Watch ${id.value} not found');
}
