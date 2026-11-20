import 'dart:io';

import 'package:dupe/core/database/app_database.dart';
import 'package:dupe/core/database/local_stores.dart';
import 'package:dupe/features/collection/domain/collection_type.dart';
import 'package:dupe/features/scan/domain/store_check.dart';
import 'package:dupe/features/scan/presentation/store/store_haptics.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

import '../../../helpers/app_harness.dart';
import '../../../helpers/fake_app_shortcuts.dart';
import '../../../helpers/fake_sources.dart';
import '../../../helpers/scan_helpers.dart';

/// Records the vibrations sent to Android (timings of each waveform).
List<List<Object?>> recordHaptics(WidgetTester tester) {
  final calls = <List<Object?>>[];
  final messenger = tester.binding.defaultBinaryMessenger
    ..setMockMethodCallHandler(StoreHaptics.channel, (call) async {
      calls.add((call.arguments as Map<Object?, Object?>)['timings']! as List);
      return null;
    });
  addTearDown(
    () => messenger.setMockMethodCallHandler(StoreHaptics.channel, null),
  );
  return calls;
}

void main() {
  test('each verdict has its own vibration pattern', () {
    final patterns = {
      for (final v in StoreVerdict.values) '${StoreHaptics.pattern(v).timings}',
    };
    expect(patterns, hasLength(4));
    for (final v in StoreVerdict.values) {
      final p = StoreHaptics.pattern(v);
      expect(p.amplitudes, hasLength(p.timings.length));
    }
  });

  test('only "owned" vibrates long: the others are short pulses', () {
    expect(StoreHaptics.pattern(StoreVerdict.owned).timings[1], 400);
    for (final v in StoreVerdict.values.where((v) => v != StoreVerdict.owned)) {
      final pulses = StoreHaptics.pattern(v).timings.skip(1);
      expect(pulses.every((ms) => ms <= 150), isTrue, reason: '$v');
    }
  });

  testWidgets('store mode vibrates with the verdict, unless turned off', (
    tester,
  ) async {
    final haptics = recordHaptics(tester);
    late AppDatabase database;
    await pumpApp(
      tester,
      size: desktopSize,
      overrides: [fakeMetadataSources(error: const SocketException('offline'))],
      seed: (db) async {
        database = db;
        final repo = repoOf(db);
        await repo.saveItem(
          repo
              .newItem(CollectionType.livre)
              .copyWith(title: 'Dune', isbn13: duneIsbn),
        );
      },
    );
    await openScan(tester);
    await typeCode(tester, duneIsbn);
    expect(find.byKey(const Key('store_owned')), findsOneWidget);
    expect(haptics, [StoreHaptics.pattern(StoreVerdict.owned).timings]);

    await tester.runAsync(
      () => AppSettingsStore(database).set(StoreHaptics.enabledKey, '0'),
    );
    await typeCode(tester, '9782070360024');
    await tester.pump(const Duration(seconds: 1));
    expect(find.byKey(const Key('store_unknown')), findsOneWidget);
    expect(haptics, [StoreHaptics.pattern(StoreVerdict.owned).timings]);
  }, variant: linux);

  testWidgets('the home-screen shortcut opens the scan', (tester) async {
    final shortcuts = FakeAppShortcuts();
    await pumpApp(tester, shortcuts: shortcuts);
    expect(shortcuts.scanTitle, 'Scanner');

    shortcuts.openScan();
    await tester.pumpAndSettle();
    expect(find.widgetWithText(AppBar, 'Scanner'), findsOneWidget);
    expect(find.byKey(const Key('scanModeSelector')), findsOneWidget);
  });
}
