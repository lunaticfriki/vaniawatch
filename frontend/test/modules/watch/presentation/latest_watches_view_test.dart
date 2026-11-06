import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/modules/watch/presentation/latest_watches_view.dart';
import 'package:frontend/modules/watch/presentation/watch_card_view.dart';

import '../application/watch_read_model_mother.dart';
import '../../../support/pump.dart';

void main() {
  group('LatestWatchesView', () {
    testWidgets('shows a card per watch and goes to all watches', (
      tester,
    ) async {
      var seeAll = false;

      await tester.pumpView(
        LatestWatchesView(
          watches: WatchReadModelMother.many(count: 2),
          onSeeAll: () => seeAll = true,
        ),
      );
      await tester.tap(find.text(LatestWatchesView.seeAllLabel));

      expect(find.byType(WatchCardView), findsNWidgets(2));
      expect(seeAll, isTrue);
    });

    testWidgets('says so when the collection is empty', (tester) async {
      await tester.pumpView(LatestWatchesView(watches: [], onSeeAll: () {}));

      expect(find.text(LatestWatchesView.emptyMessage), findsOneWidget);
      expect(find.byType(WatchCardView), findsNothing);
    });
  });
}
