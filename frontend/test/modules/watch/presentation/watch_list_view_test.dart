import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/modules/watch/presentation/watch_card_view.dart';
import 'package:frontend/modules/watch/presentation/watch_list_view.dart';

import '../application/watch_read_model_mother.dart';
import '../../../support/pump.dart';

void main() {
  group('WatchListView', () {
    testWidgets('shows the count and a card per watch', (tester) async {
      await tester.pumpView(
        WatchListView(watches: WatchReadModelMother.many(count: 3)),
      );

      expect(find.text('3 watches'), findsOneWidget);
      expect(find.byType(WatchCardView), findsNWidgets(3));
    });

    testWidgets('uses the singular for one watch', (tester) async {
      await tester.pumpView(
        WatchListView(watches: WatchReadModelMother.many(count: 1)),
      );

      expect(find.text('1 watch'), findsOneWidget);
    });

    testWidgets('says so when the collection is empty', (tester) async {
      await tester.pumpView(const WatchListView(watches: []));

      expect(find.text(WatchListView.emptyMessage), findsOneWidget);
    });
  });
}
