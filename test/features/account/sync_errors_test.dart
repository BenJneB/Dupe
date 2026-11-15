import 'package:dupe/core/logging/app_log.dart';
import 'package:dupe/core/sync/sync_providers.dart';
import 'package:dupe/core/sync/sync_remote.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/app_harness.dart';
import '../../helpers/fake_sync_auth.dart';
import '../../helpers/fake_sync_remote.dart';
import 'sync_flow_test.dart' show openSettings;

void main() {
  testWidgets('sync failures: logged once, shown as a sentence', (
    tester,
  ) async {
    final remote = FakeSyncRemote()..offline = true;
    await appLog.clear();
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
    // Two more periodic attempts while offline.
    await tester.pump(const Duration(seconds: 31));
    await tester.pump(const Duration(seconds: 31));
    await tester.pumpAndSettle();
    List<LogEntry> syncLogs() =>
        appLog.entries.where((e) => e.source == 'sync').toList();
    expect(syncLogs(), hasLength(1));
    expect(syncLogs().single.level, LogLevel.warning);

    remote
      ..offline = false
      ..failure = const SyncException('new row violates row-level security');
    await tester.pump(const Duration(seconds: 31));
    await tester.pumpAndSettle();
    await openSettings(tester);
    expect(
      find.text(
        'Erreur de synchronisation : Le serveur a refusé la demande '
        '(détails dans À propos → Journal).',
      ),
      findsOneWidget,
    );
    expect(syncLogs(), hasLength(2));
    expect(syncLogs().last.level, LogLevel.error);
    expect(syncLogs().last.message, contains('row-level security'));
  });
}
