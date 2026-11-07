import 'package:bloc_test/bloc_test.dart';
import 'package:frontend/modules/watch/application/watch_collection_repository.dart';
import 'package:frontend/modules/watch/application/watch_image_picker.dart';
import 'package:frontend/modules/watch/application/watch_image_storage.dart';
import 'package:frontend/modules/watch/application/watch_read_service.dart';
import 'package:frontend/modules/watch/application/watch_write_service.dart';
import 'package:frontend/modules/watch/presentation/cubit/add_watch_cubit.dart';
import 'package:frontend/modules/watch/presentation/cubit/add_watch_state.dart';
import 'package:frontend/modules/watch/presentation/cubit/watch_list_cubit.dart';
import 'package:frontend/modules/watch/presentation/cubit/watch_list_state.dart';
import 'package:mocktail/mocktail.dart';

class MockWatchCollectionRepository extends Mock
    implements WatchCollectionRepository {}

class MockWatchReadService extends Mock implements WatchReadService {}

class MockWatchWriteService extends Mock implements WatchWriteService {}

class MockWatchImageStorage extends Mock implements WatchImageStorage {}

class MockWatchImagePicker extends Mock implements WatchImagePicker {}

class MockWatchListCubit extends MockCubit<WatchListState>
    implements WatchListCubit {}

class MockAddWatchCubit extends MockCubit<AddWatchState>
    implements AddWatchCubit {}
