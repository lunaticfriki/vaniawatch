import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/modules/watch/application/watch_draft.dart';
import 'package:frontend/modules/watch/application/watch_image_picker.dart';
import 'package:frontend/modules/watch/application/watch_write_service.dart';
import 'package:frontend/modules/watch/presentation/add_watch_form_view.dart';
import 'package:frontend/modules/watch/presentation/add_watch_image_view.dart';
import 'package:frontend/modules/watch/presentation/add_watch_page.dart';
import 'package:core/core.dart';
import 'package:mocktail/mocktail.dart';

import '../../../support/mocks.dart';
import '../application/command/create_watch_command_mother.dart';
import '../application/watch_image_mother.dart';

void main() {
  group('AddWatchPage', () {
    late MockWatchWriteService writeService;
    late MockWatchImagePicker picker;
    late int saves;

    setUpAll(() => registerFallbackValue(CreateWatchCommandMother.valid()));

    setUp(() {
      writeService = MockWatchWriteService();
      picker = MockWatchImagePicker();
      saves = 0;
      when(() => writeService.acceptsImages).thenReturn(true);
    });

    Future<void> pumpPage(WidgetTester tester) async {
      tester.view.physicalSize = const Size(900, 1600);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);
      await tester.pumpWidget(
        MultiRepositoryProvider(
          providers: [
            RepositoryProvider<WatchWriteService>.value(value: writeService),
            RepositoryProvider<WatchImagePicker>.value(value: picker),
          ],
          child: MaterialApp(
            home: Scaffold(
              body: SingleChildScrollView(
                child: AddWatchPage(onSaved: () => saves++),
              ),
            ),
          ),
        ),
      );
    }

    Future<void> fillRequired(WidgetTester tester) async {
      await tester.enterText(
        find.byKey(AddWatchFormView.nameKey),
        'Speedmaster',
      );
      await tester.enterText(find.byKey(AddWatchFormView.brandKey), 'Omega');
    }

    testWidgets('shows its title and the form', (tester) async {
      await pumpPage(tester);

      expect(find.text(AddWatchPage.title), findsOneWidget);
      expect(find.byType(AddWatchFormView), findsOneWidget);
    });

    testWidgets('previews the image chosen in the picker', (tester) async {
      when(
        picker.pick,
      ).thenAnswer((_) async => WatchImageMother.random(fileName: 'moon.png'));
      await pumpPage(tester);

      await tester.tap(find.text(AddWatchImageView.chooseLabel));
      await tester.pump();

      expect(find.text('moon.png'), findsOneWidget);
    });

    testWidgets('keeps the form as it was when the picker is cancelled', (
      tester,
    ) async {
      when(picker.pick).thenAnswer((_) async => null);
      await pumpPage(tester);

      await tester.tap(find.text(AddWatchImageView.chooseLabel));
      await tester.pump();

      expect(find.byType(Image), findsNothing);
    });

    testWidgets('saves the watch, confirms and moves on', (tester) async {
      when(() => writeService.create(any())).thenAnswer((_) async => 'new-id');
      await pumpPage(tester);

      await fillRequired(tester);
      await tester.tap(find.text(AddWatchFormView.submitLabel));
      await tester.pump();

      expect(saves, 1);
      expect(find.text(AddWatchPage.savedMessage), findsOneWidget);
    });

    testWidgets('shows the domain message of a rejected field', (tester) async {
      const error = InvalidWatchNameError('');
      when(() => writeService.create(any()))
          .thenThrow(WatchDraftRejectedException([error]));
      await pumpPage(tester);

      await tester.tap(find.text(AddWatchFormView.submitLabel));
      await tester.pump();

      expect(find.text(error.message), findsOneWidget);
      expect(saves, 0);
    });
  });
}
