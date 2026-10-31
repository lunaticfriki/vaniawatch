import 'package:core/src/user/value_objects/user_id_value_object.dart';
import 'package:core/src/watch/entities/watch_entity.dart';
import 'package:core/src/watch/value_objects/watch_id_value_object.dart';

abstract class WatchRepository {
  Future<Watch?> findById(WatchId id);

  Future<List<Watch>> findByOwner(UserId owner);

  Future<void> save(Watch watch);

  Future<void> delete(WatchId id);
}
