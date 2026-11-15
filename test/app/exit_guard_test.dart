import 'package:dupe/app/exit_guard.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

import '../helpers/app_harness.dart';

void main() {
  testWidgets('Android: back on a tab root needs a second press to quit', (
    tester,
  ) async {
    var exits = 0;
    tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
      SystemChannels.platform,
      (call) async {
        if (call.method == 'SystemNavigator.pop') exits++;
        return null;
      },
    );
    await pumpApp(tester);

    await tester.binding.handlePopRoute();
    await tester.pump();
    expect(find.byKey(const Key('exitHint')), findsOneWidget);
    expect(exits, 0);

    // Too late: the hint expired, the next press only shows it again.
    await tester.pump(ExitGuard.window + const Duration(seconds: 1));
    await tester.pumpAndSettle();
    await tester.binding.handlePopRoute();
    await tester.pump();
    expect(exits, 0);

    await tester.binding.handlePopRoute();
    await tester.pump();
    expect(exits, 1);
    await tester.pumpAndSettle();
  });
}
