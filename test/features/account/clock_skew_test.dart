import 'package:dupe/core/logging/app_log.dart';
import 'package:dupe/core/sync/clock_check.dart';
import 'package:dupe/core/sync/sync_providers.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/app_harness.dart';
import '../../helpers/fake_sync_auth.dart';
import '../../helpers/fake_sync_remote.dart';
import '../../helpers/screen_helpers.dart';

void main() {
  test('more than 2 minutes apart is a wrong clock', () {
    final server = DateTime.utc(2026, 11, 14, 10);
    expect(
      ClockCheck.skew(server.add(const Duration(seconds: 90)), server),
      isNull,
    );
    expect(
      ClockCheck.skew(server.add(const Duration(minutes: 3)), server),
      const Duration(minutes: 3),
    );
    expect(
      ClockCheck.skew(server.subtract(const Duration(minutes: 5)), server),
      const Duration(minutes: -5),
    );
  });

  testWidgets('a device clock 10 minutes ahead is reported, once', (
    tester,
  ) async {
    await appLog.clear();
    final remote = FakeSyncRemote()
      ..serverNow = DateTime.now().subtract(const Duration(minutes: 10));
    await pumpApp(
      tester,
      overrides: [
        syncAuthProvider.overrideWithValue(
          FakeSyncAuth(signedInAs: 'moi@exemple.be'),
        ),
        syncRemoteProvider.overrideWithValue(remote),
      ],
    );
    await tester.pumpAndSettle();
    await openSettings(tester);
    expect(
      find.textContaining('semble fausse (écart de 10 min'),
      findsOneWidget,
    );

    // Further syncs within the hour: no new check, no new journal entry.
    await tester.pump(const Duration(seconds: 31));
    await tester.pumpAndSettle();
    expect(
      appLog.entries.where((e) => e.message.contains('Device clock')),
      hasLength(1),
    );
  });

  testWidgets('no warning when the server time is unknown', (tester) async {
    await pumpApp(
      tester,
      overrides: [
        syncAuthProvider.overrideWithValue(
          FakeSyncAuth(signedInAs: 'moi@exemple.be'),
        ),
        syncRemoteProvider.overrideWithValue(FakeSyncRemote()),
      ],
    );
    await tester.pumpAndSettle();
    await openSettings(tester);
    expect(find.textContaining('semble fausse'), findsNothing);
    expect(find.textContaining('Synchronisé'), findsOneWidget);
  });
}
