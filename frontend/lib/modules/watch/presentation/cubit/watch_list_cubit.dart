import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/modules/watch/application/query/list_watches_query.dart';
import 'package:frontend/modules/watch/application/watch_read_service.dart';
import 'package:frontend/modules/watch/presentation/cubit/watch_list_state.dart';

class WatchListCubit extends Cubit<WatchListState> {
  WatchListCubit(this._readService) : super(const WatchListLoading());

  final WatchReadService _readService;

  Future<void> load(ListWatchesQuery query) async {
    emit(const WatchListLoading());
    try {
      emit(WatchListLoaded(await _readService.list(query)));
    } on Exception {
      emit(const WatchListFailure());
    }
  }
}
