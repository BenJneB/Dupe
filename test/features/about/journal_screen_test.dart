import 'package:dupe/app/router.dart';
import 'package:dupe/core/logging/app_log.dart';
import 'package:dupe/features/backup/data/file_io.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

import '../../helpers/app_harness.dart';
import '../../helpers/fake_file_io.dart';

void main() {
  testWidgets('the journal lists, copies, shares and clears entries', (
    tester,
  ) async {
    String? copied;
    tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
      SystemChannels.platform,
      (call) async {
        if (call.method == 'Clipboard.setData') {
          copied = (call.arguments as Map<Object?, Object?>)['text'] as String?;
        }
        return null;
      },
    );
    addTearDown(
      () => tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
        SystemChannels.platform,
        null,
      ),
    );
    final files = FakeFileIo();
    await pumpApp(tester, overrides: [fileIoProvider.overrideWithValue(files)]);
    await appLog.clear();
    appLog
      ..info('sync', 'sent 2, received 0')
      ..error('backup', const FormatException('ligne 3'));

    ProviderScope.containerOf(tester.element(find.byType(Scaffold).first))
        .read(appRouterProvider)
        .go(AppRoutes.about);
    await tester.pumpAndSettle();
    await tester.scrollUntilVisible(find.byKey(const Key('journalTile')), 200);
    await tester.tap(find.byKey(const Key('journalTile')));
    await tester.pumpAndSettle();

    // Newest first.
    final tiles = find.byType(ListTile);
    expect(tiles, findsNWidgets(2));
    expect(
      find.descendant(of: tiles.first, matching: find.textContaining('backup')),
      findsOneWidget,
    );
    expect(find.text('FormatException: ligne 3'), findsOneWidget);

    await tester.tap(find.byKey(const Key('journalCopy')));
    await tester.pumpAndSettle();
    expect(find.text('Journal copié'), findsOneWidget);
    expect(copied, contains('[sync] sent 2, received 0'));

    await tester.tap(find.byKey(const Key('journalShare')));
    await tester.pumpAndSettle();
    expect(files.saved.keys.single, startsWith('dupe-journal-'));
    expect(files.text(files.saved.keys.single), contains('ligne 3'));

    await tester.tap(find.byKey(const Key('journalClear')));
    await tester.pumpAndSettle();
    expect(find.text('Rien à signaler'), findsOneWidget);
  });
}
