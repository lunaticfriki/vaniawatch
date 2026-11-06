import 'package:frontend/modules/watch/application/watch_read_model.dart';

sealed class WatchListState {
  const WatchListState();
}

final class WatchListLoading extends WatchListState {
  const WatchListLoading();
}

final class WatchListLoaded extends WatchListState {
  const WatchListLoaded(this.watches);

  final List<WatchReadModel> watches;
}

final class WatchListFailure extends WatchListState {
  const WatchListFailure();
}
