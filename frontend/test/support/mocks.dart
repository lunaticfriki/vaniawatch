import 'package:bloc_test/bloc_test.dart';
import 'package:frontend/modules/watch/application/watch_collection_repository.dart';
import 'package:frontend/modules/watch/application/watch_read_service.dart';
import 'package:frontend/modules/watch/presentation/cubit/watch_list_cubit.dart';
import 'package:frontend/modules/watch/presentation/cubit/watch_list_state.dart';
import 'package:mocktail/mocktail.dart';

class MockWatchCollectionRepository extends Mock
    implements WatchCollectionRepository {}

class MockWatchReadService extends Mock implements WatchReadService {}

class MockWatchListCubit extends MockCubit<WatchListState>
    implements WatchListCubit {}
