import 'package:core/testing.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/modules/watch/application/command/create_watch_command_handler.dart';
import 'package:frontend/modules/watch/application/watch_write_service.dart';
import 'package:mocktail/mocktail.dart';

import '../../../support/mocks.dart';
import 'command/create_watch_command_mother.dart';
import 'watch_draft_mother.dart';

void main() {
  group('WatchWriteService', () {
    late MockWatchCollectionRepository watches;
    late MockWatchImageStorage images;
    late WatchWriteService service;

    setUpAll(() => registerFallbackValue(WatchDraftMother.random()));

    setUp(() {
      watches = MockWatchCollectionRepository();
      images = MockWatchImageStorage();
      service = WatchWriteServiceImpl(
        createWatch: CreateWatchCommandHandler(watches, images),
        images: images,
      );
    });

    test('creates a watch through its handler', () async {
      final id = WatchIdMother.random();
      when(() => watches.add(any())).thenAnswer((_) async => id);

      final result = await service.create(CreateWatchCommandMother.valid());

      expect(result, id.value);
    });

    test('accepts images only when the storage is available', () {
      when(() => images.isAvailable).thenReturn(true);
      expect(service.acceptsImages, isTrue);

      when(() => images.isAvailable).thenReturn(false);
      expect(service.acceptsImages, isFalse);
    });
  });
}
