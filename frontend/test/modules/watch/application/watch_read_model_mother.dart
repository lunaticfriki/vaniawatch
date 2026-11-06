import 'package:core/testing.dart';
import 'package:frontend/modules/watch/application/watch_read_model.dart';

abstract final class WatchReadModelMother {
  static WatchReadModel random() =>
      WatchReadModel.fromDomain(WatchMother.restored());

  static WatchReadModel withoutImage() =>
      WatchReadModel.fromDomain(WatchMother.withoutImage());

  static List<WatchReadModel> many({int count = 3}) =>
      List.generate(count, (_) => random());
}
