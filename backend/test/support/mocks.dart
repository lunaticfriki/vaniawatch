import 'package:backend/modules/watch/application/watch_read_service.dart';
import 'package:backend/modules/watch/application/watch_write_service.dart';
import 'package:backend/shared/application/clock_service.dart';
import 'package:core/core.dart';
import 'package:dart_frog/dart_frog.dart';
import 'package:mocktail/mocktail.dart';

class MockWatchRepository extends Mock implements WatchRepository {}

class MockClockService extends Mock implements ClockService {}

class MockWatchReadService extends Mock implements WatchReadService {}

class MockWatchWriteService extends Mock implements WatchWriteService {}

class MockRequestContext extends Mock implements RequestContext {}
