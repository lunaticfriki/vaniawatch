import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/modules/watch/presentation/watch_list_failure_view.dart';

import '../../../support/pump.dart';

void main() {
  group('WatchListFailureView', () {
    testWidgets('explains the failure and retries on tap', (tester) async {
      var retried = false;

      await tester.pumpView(
        WatchListFailureView(onRetry: () => retried = true),
      );
      await tester.tap(find.text(WatchListFailureView.retryLabel));

      expect(find.text(WatchListFailureView.message), findsOneWidget);
      expect(retried, isTrue);
    });
  });
}
