import 'package:bloc_test/bloc_test.dart';
import 'package:core/core.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/modules/watch/application/command/create_watch_command.dart';
import 'package:frontend/modules/watch/application/watch_collection_repository.dart';
import 'package:frontend/modules/watch/application/watch_draft.dart';
import 'package:frontend/modules/watch/application/watch_image_storage.dart';
import 'package:frontend/modules/watch/presentation/cubit/add_watch_cubit.dart';
import 'package:frontend/modules/watch/presentation/cubit/add_watch_state.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../support/mocks.dart';
import '../../application/command/create_watch_command_mother.dart';
import '../../application/watch_image_mother.dart';
import '../add_watch_form_values_mother.dart';

void main() {
  group('AddWatchCubit', () {
    late MockWatchWriteService writeService;
    final image = WatchImageMother.random();

    setUpAll(() => registerFallbackValue(CreateWatchCommandMother.valid()));

    setUp(() {
      writeService = MockWatchWriteService();
      when(() => writeService.acceptsImages).thenReturn(true);
    });

    CreateWatchCommand sentCommand() =>
        verify(() => writeService.create(captureAny())).captured.single
            as CreateWatchCommand;

    test('starts editing, without an image, saying if images are accepted', () {
      when(() => writeService.acceptsImages).thenReturn(false);

      final state = AddWatchCubit(writeService).state;

      expect(state, isA<AddWatchEditing>());
      expect(state.image, isNull);
      expect(state.acceptsImages, isFalse);
    });

    blocTest<AddWatchCubit, AddWatchState>(
      'keeps the picked image',
      build: () => AddWatchCubit(writeService),
      act: (cubit) => cubit.selectImage(image),
      expect: () => [
        isA<AddWatchEditing>().having((state) => state.image, 'image', image),
      ],
    );

    blocTest<AddWatchCubit, AddWatchState>(
      'ignores a picked image when images are not accepted',
      setUp: () => when(() => writeService.acceptsImages).thenReturn(false),
      build: () => AddWatchCubit(writeService),
      act: (cubit) => cubit.selectImage(image),
      expect: () => <AddWatchState>[],
    );

    blocTest<AddWatchCubit, AddWatchState>(
      'removes the picked image',
      build: () => AddWatchCubit(writeService),
      act: (cubit) => cubit
        ..selectImage(image)
        ..removeImage(),
      expect: () => [
        isA<AddWatchEditing>().having((state) => state.image, 'image', image),
        isA<AddWatchEditing>().having((state) => state.image, 'image', isNull),
      ],
    );

    blocTest<AddWatchCubit, AddWatchState>(
      'submits the form with the image and emits the new id',
      setUp: () =>
          when(() => writeService.create(any()))
              .thenAnswer((_) async => 'new-id'),
      build: () => AddWatchCubit(writeService),
      act: (cubit) async {
        cubit.selectImage(image);
        await cubit.submit(AddWatchFormValuesMother.valid());
      },
      expect: () => [
        isA<AddWatchEditing>(),
        isA<AddWatchSubmitting>().having(
          (state) => state.image,
          'image',
          image,
        ),
        isA<AddWatchSubmitted>().having((state) => state.id, 'id', 'new-id'),
      ],
      verify: (_) {
        final command = sentCommand();
        expect(command.image, image);
        expect(command.tags, ['chrono', 'steel']);
        expect(command.complications, ['chronograph', 'date']);
      },
    );

    blocTest<AddWatchCubit, AddWatchState>(
      'maps each rejected field to its error message',
      setUp: () => when(() => writeService.create(any())).thenThrow(
        WatchDraftRejectedException([
          InvalidWatchNameError(''),
          InvalidWatchBrandError(''),
          InvalidWatchTypeError('x'),
          InvalidWatchCategoryError('x'),
          InvalidWatchDescriptionError(2001),
          InvalidWatchTagError(''),
        ]),
      ),
      build: () => AddWatchCubit(writeService),
      act: (cubit) => cubit.submit(AddWatchFormValuesMother.invalid()),
      expect: () => [
        isA<AddWatchSubmitting>(),
        isA<AddWatchEditing>()
            .having(
              (state) => state.fieldErrors.keys.toSet(),
              'fields',
              AddWatchField.values.toSet(),
            )
            .having(
              (state) => state.fieldErrors[AddWatchField.name],
              'name error',
              InvalidWatchNameError('').message,
            )
            .having((state) => state.failure, 'failure', isNull),
      ],
    );

    blocTest<AddWatchCubit, AddWatchState>(
      'maps too many tags to the tags field',
      setUp: () => when(() => writeService.create(any()))
          .thenThrow(WatchDraftRejectedException([InvalidWatchTagsError(21)])),
      build: () => AddWatchCubit(writeService),
      act: (cubit) => cubit.submit(AddWatchFormValuesMother.invalid()),
      expect: () => [
        isA<AddWatchSubmitting>(),
        isA<AddWatchEditing>().having(
          (state) => state.fieldErrors.keys,
          'fields',
          [AddWatchField.tags],
        ),
      ],
    );

    blocTest<AddWatchCubit, AddWatchState>(
      'reports a failed upload and keeps the image',
      setUp: () =>
          when(() => writeService.create(any()))
              .thenThrow(const WatchImageUploadFailedException()),
      build: () => AddWatchCubit(writeService),
      act: (cubit) async {
        cubit.selectImage(image);
        await cubit.submit(AddWatchFormValuesMother.valid());
      },
      skip: 2,
      expect: () => [
        isA<AddWatchEditing>()
            .having((state) => state.failure, 'failure', AddWatchFailure.upload)
            .having((state) => state.image, 'image', image),
      ],
    );

    blocTest<AddWatchCubit, AddWatchState>(
      'reports a failed save',
      setUp: () =>
          when(() => writeService.create(any()))
              .thenThrow(const WatchCollectionUnavailableException()),
      build: () => AddWatchCubit(writeService),
      act: (cubit) => cubit.submit(AddWatchFormValuesMother.valid()),
      skip: 1,
      expect: () => [
        isA<AddWatchEditing>().having(
          (state) => state.failure,
          'failure',
          AddWatchFailure.save,
        ),
      ],
    );

    blocTest<AddWatchCubit, AddWatchState>(
      'ignores a second submit while saving',
      setUp: () =>
          when(() => writeService.create(any()))
              .thenAnswer((_) async => 'new-id'),
      build: () => AddWatchCubit(writeService),
      act: (cubit) => Future.wait([
        cubit.submit(AddWatchFormValuesMother.valid()),
        cubit.submit(AddWatchFormValuesMother.valid()),
      ]),
      expect: () => [isA<AddWatchSubmitting>(), isA<AddWatchSubmitted>()],
      verify: (_) => verify(() => writeService.create(any())).called(1),
    );
  });
}
