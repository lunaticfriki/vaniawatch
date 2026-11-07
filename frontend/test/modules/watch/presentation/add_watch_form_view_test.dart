import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/modules/watch/application/watch_draft.dart';
import 'package:frontend/modules/watch/presentation/add_watch_form_values.dart';
import 'package:frontend/modules/watch/presentation/add_watch_form_view.dart';
import 'package:frontend/modules/watch/presentation/add_watch_image_view.dart';
import 'package:frontend/modules/watch/presentation/cubit/add_watch_state.dart';

import '../../../support/pump.dart';
import '../application/watch_image_mother.dart';

void main() {
  group('AddWatchFormView', () {
    late List<AddWatchFormValues> submitted;
    late int picks;
    late int removals;

    setUp(() {
      submitted = [];
      picks = 0;
      removals = 0;
    });

    Future<void> pumpForm(WidgetTester tester, {AddWatchState? state}) async {
      tester.view.physicalSize = const Size(900, 1600);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);
      await tester.pumpView(
        SingleChildScrollView(
          child: AddWatchFormView(
            state:
                state ??
                const AddWatchEditing(image: null, acceptsImages: true),
            types: WatchDraft.types,
            categories: WatchDraft.categories,
            onPickImage: () => picks++,
            onRemoveImage: () => removals++,
            onSubmit: submitted.add,
          ),
        ),
      );
    }

    Finder field(Key key) => find.byKey(key);

    testWidgets('submits what the user typed and chose', (tester) async {
      await pumpForm(tester);

      await tester.enterText(field(AddWatchFormView.nameKey), 'Speedmaster');
      await tester.enterText(field(AddWatchFormView.brandKey), 'Omega');
      await tester.tap(find.text('Digital'));
      await tester.tap(find.text('Quartz'));
      await tester.enterText(
        field(AddWatchFormView.descriptionKey),
        'Moonwatch',
      );
      await tester.enterText(field(AddWatchFormView.tagsKey), 'chrono, steel');
      await tester.enterText(
        field(AddWatchFormView.complicationsKey),
        'chronograph',
      );
      await tester.tap(find.text(AddWatchFormView.submitLabel));

      final values = submitted.single;
      expect(values.name, 'Speedmaster');
      expect(values.brand, 'Omega');
      expect(values.type, 'digital');
      expect(values.category, 'quartz');
      expect(values.description, 'Moonwatch');
      expect(values.tagList, ['chrono', 'steel']);
      expect(values.complicationList, ['chronograph']);
    });

    testWidgets('starts on the first type and category', (tester) async {
      await pumpForm(tester);

      await tester.tap(find.text(AddWatchFormView.submitLabel));

      expect(submitted.single.type, WatchDraft.types.first);
      expect(submitted.single.category, WatchDraft.categories.first);
    });

    testWidgets('shows the error of each rejected field', (tester) async {
      await pumpForm(
        tester,
        state: const AddWatchEditing(
          image: null,
          acceptsImages: true,
          fieldErrors: {
            AddWatchField.name: 'name is wrong',
            AddWatchField.tags: 'tags are wrong',
          },
        ),
      );

      expect(find.text('name is wrong'), findsOneWidget);
      expect(find.text('tags are wrong'), findsOneWidget);
    });

    testWidgets('explains a failed upload', (tester) async {
      await pumpForm(
        tester,
        state: const AddWatchEditing(
          image: null,
          acceptsImages: true,
          failure: AddWatchFailure.upload,
        ),
      );

      expect(find.text(AddWatchFormView.uploadFailedMessage), findsOneWidget);
    });

    testWidgets('explains a failed save', (tester) async {
      await pumpForm(
        tester,
        state: const AddWatchEditing(
          image: null,
          acceptsImages: true,
          failure: AddWatchFailure.save,
        ),
      );

      expect(find.text(AddWatchFormView.saveFailedMessage), findsOneWidget);
    });

    testWidgets('disables saving while the watch is being saved', (
      tester,
    ) async {
      await pumpForm(
        tester,
        state: const AddWatchSubmitting(image: null, acceptsImages: true),
      );

      await tester.tap(find.text(AddWatchFormView.savingLabel));

      expect(submitted, isEmpty);
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('asks for an image', (tester) async {
      await pumpForm(tester);

      await tester.tap(find.text(AddWatchImageView.chooseLabel));

      expect(picks, 1);
      expect(find.byType(Image), findsNothing);
    });

    testWidgets('previews the picked image and removes it', (tester) async {
      await pumpForm(
        tester,
        state: AddWatchEditing(
          image: WatchImageMother.random(fileName: 'moonwatch.png'),
          acceptsImages: true,
        ),
      );

      expect(find.byType(Image), findsOneWidget);
      expect(find.text('moonwatch.png'), findsOneWidget);
      expect(find.text(AddWatchImageView.changeLabel), findsOneWidget);

      await tester.tap(find.text(AddWatchImageView.removeLabel));

      expect(removals, 1);
    });

    testWidgets('explains that images are not available yet', (tester) async {
      await pumpForm(
        tester,
        state: const AddWatchEditing(image: null, acceptsImages: false),
      );

      await tester.tap(find.text(AddWatchImageView.chooseLabel));

      expect(picks, 0);
      expect(find.text(AddWatchImageView.unavailableMessage), findsOneWidget);
    });
  });
}
