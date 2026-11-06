import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/modules/watch/presentation/watch_card_view.dart';

import '../application/watch_read_model_mother.dart';
import '../../../support/pump.dart';

void main() {
  group('WatchCardView', () {
    testWidgets('shows the name, brand, type, category and tags', (
      tester,
    ) async {
      final watch = WatchReadModelMother.random();

      await tester.pumpView(WatchCardView(watch: watch));

      expect(find.text(watch.name), findsOneWidget);
      expect(
        find.text('${watch.brand} · ${watch.type} · ${watch.category}'),
        findsOneWidget,
      );
      for (final tag in watch.tags) {
        expect(find.widgetWithText(Chip, tag), findsOneWidget);
      }
    });
  });
}
