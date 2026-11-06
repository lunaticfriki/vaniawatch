import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/modules/watch/presentation/watch_list_skeleton.dart';

import '../../../support/pump.dart';

void main() {
  group('WatchListSkeleton', () {
    testWidgets('shows placeholder cards', (tester) async {
      await tester.pumpView(const WatchListSkeleton(count: 3));

      expect(find.byType(WatchCardPlaceholder), findsNWidgets(3));
    });
  });
}
