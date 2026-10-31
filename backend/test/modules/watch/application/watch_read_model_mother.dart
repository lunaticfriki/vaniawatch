import 'package:backend/modules/watch/application/watch_read_model.dart';
import 'package:core/testing.dart';

abstract final class WatchReadModelMother {
  static WatchReadModel random() =>
      WatchReadModel.fromDomain(WatchMother.restored());

  static List<WatchReadModel> many({int count = 3}) =>
      List.generate(count, (_) => random());
}
