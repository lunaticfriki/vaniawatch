import 'package:core/core.dart';
import 'package:core/testing.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/modules/watch/application/command/create_watch_command_handler.dart';
import 'package:frontend/modules/watch/application/watch_collection_repository.dart';
import 'package:frontend/modules/watch/application/watch_draft.dart';
import 'package:frontend/modules/watch/application/watch_image_storage.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../support/mocks.dart';
import '../watch_draft_mother.dart';
import '../watch_image_mother.dart';
import 'create_watch_command_mother.dart';

void main() {
  group('CreateWatchCommandHandler', () {
    late MockWatchCollectionRepository watches;
    late MockWatchImageStorage images;
    late CreateWatchCommandHandler handler;

    setUpAll(() {
      registerFallbackValue(WatchDraftMother.random());
      registerFallbackValue(WatchImageMother.random());
    });

    setUp(() {
      watches = MockWatchCollectionRepository();
      images = MockWatchImageStorage();
      handler = CreateWatchCommandHandler(watches, images);
    });

    WatchDraft addedDraft() =>
        verify(() => watches.add(captureAny())).captured.single as WatchDraft;

    test('adds the watch and returns its id', () async {
      final id = WatchIdMother.random();
      when(() => watches.add(any())).thenAnswer((_) async => id);
      final command = CreateWatchCommandMother.valid();

      final result = await handler.handle(command);

      expect(result, id.value);
      final draft = addedDraft();
      expect(draft.name, WatchName.create(command.name));
      expect(draft.brand, WatchBrand.create(command.brand));
      expect(draft.type, WatchType.create(command.type));
      expect(draft.category, WatchCategory.create(command.category));
      expect(draft.complications, command.complications);
      expect(draft.imageUrl.isEmpty, isTrue);
      verifyNever(() => images.upload(any()));
    });

    test('uploads the image and saves the watch with its url', () async {
      final imageUrl = WatchImageUrlMother.random();
      final image = WatchImageMother.random();
      when(() => images.upload(image)).thenAnswer((_) async => imageUrl);
      when(() => watches.add(any()))
          .thenAnswer((_) async => WatchIdMother.random());

      await handler.handle(CreateWatchCommandMother.valid(image: image));

      expect(addedDraft().imageUrl, imageUrl);
    });

    test('rejects invalid fields before uploading or saving', () async {
      await expectLater(
        handler.handle(
          CreateWatchCommandMother.invalid(image: WatchImageMother.random()),
        ),
        throwsA(isA<WatchDraftRejectedException>()),
      );

      verifyNever(() => images.upload(any()));
      verifyNever(() => watches.add(any()));
    });

    test('saves nothing when the upload fails', () async {
      when(() => images.upload(any()))
          .thenThrow(const WatchImageUploadFailedException('offline'));

      await expectLater(
        handler.handle(
          CreateWatchCommandMother.valid(image: WatchImageMother.random()),
        ),
        throwsA(isA<WatchImageUploadFailedException>()),
      );

      verifyNever(() => watches.add(any()));
    });

    test('lets an unavailable collection fail the command', () async {
      when(() => watches.add(any()))
          .thenThrow(const WatchCollectionUnavailableException('down'));

      await expectLater(
        handler.handle(CreateWatchCommandMother.valid()),
        throwsA(isA<WatchCollectionUnavailableException>()),
      );
    });
  });
}
