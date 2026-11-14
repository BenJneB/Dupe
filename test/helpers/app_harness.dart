import 'package:dupe/app/app.dart';
import 'package:dupe/core/database/app_database.dart';
import 'package:dupe/core/database/database_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

const phoneSize = Size(400, 800);
const desktopSize = Size(1280, 800);

/// Pumps the whole app on an in-memory database; returns the database.
Future<AppDatabase> pumpApp(
  WidgetTester tester, {
  Size size = phoneSize,
  List<Override> overrides = const [],

  /// Writes initial data before the app (and its drift streams) starts.
  Future<void> Function(AppDatabase db)? seed,
}) async {
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);
  final db = AppDatabase.memory();
  await seed?.call(db);
  await tester.pumpWidget(
    ProviderScope(
      overrides: [appDatabaseProvider.overrideWithValue(db), ...overrides],
      child: const DupeApp(),
    ),
  );
  await tester.pumpAndSettle();
  addTearDown(() async {
    // Dispose the tree first so drift stream subscriptions are cancelled,
    // let drift's zero-duration cleanup timers fire, then close the
    // database outside the fake-async zone (it would never complete inside).
    await tester.pumpWidget(const SizedBox());
    await tester.pump(Duration.zero);
    // Bounded so that a failed test cannot hang the whole suite.
    await tester.runAsync(
      () => db.close().timeout(const Duration(seconds: 5), onTimeout: () {}),
    );
  });
  return db;
}

/// Taps the app bar back button. `tester.pageBack()` only knows the legacy
/// `package:flutter/material.dart` BackButton, not material_ui's.
Future<void> goBack(WidgetTester tester) async {
  await tester.tap(find.byType(BackButton));
  await tester.pumpAndSettle();
}
