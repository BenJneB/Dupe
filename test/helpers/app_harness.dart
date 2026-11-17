import 'package:dupe/app/app.dart';
import 'package:dupe/core/database/app_database.dart';
import 'package:dupe/core/database/database_provider.dart';
import 'package:dupe/core/metadata/metadata_providers.dart';
import 'package:dupe/core/metadata/providers/mangadex/mangadex_covers.dart';
import 'package:dupe/core/metadata/series_lookup.dart';
import 'package:dupe/core/network/network_status.dart';
import 'package:dupe/features/backup/data/auto_backups.dart';
import 'package:dupe/features/backup/data/backup_store.dart';
import 'package:dupe/features/collection/data/series_completion_service.dart';
import 'package:dupe/features/covers/data/cover_cache.dart';
import 'package:dupe/features/covers/data/cover_providers.dart';
import 'package:dupe/features/covers/data/cover_scanner.dart';
import 'package:dupe/features/home_widget/data/home_screen_widget.dart';
import 'package:dupe/features/loans/data/loan_reminders.dart';
import 'package:dupe/features/recommendations/data/suggestion_sources.dart';
import 'package:dupe/features/scan/data/app_shortcuts.dart';
import 'package:dupe/features/search/data/voice_input.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

import 'fake_app_shortcuts.dart';
import 'fake_covers.dart';
import 'fake_home_widget.dart';
import 'fake_reminders.dart';
import 'fake_series_catalog.dart';
import 'fake_suggestion_sources.dart';
import 'fake_voice_input.dart';
import 'memory_backup_store.dart';

const phoneSize = Size(400, 800);
const desktopSize = Size(1280, 800);

/// Pumps the whole app on an in-memory database; returns the database.
Future<AppDatabase> pumpApp(
  WidgetTester tester, {
  Size size = phoneSize,
  List<Override> overrides = const [],

  /// System notifications are never used in tests.
  LoanReminders? reminders,

  /// Automatic backups (memory; never the app folder).
  BackupStore? backups,

  /// Home-screen shortcuts (never the platform plugin).
  FakeAppShortcuts? shortcuts,

  /// Home-screen widget and dictation (never the platform plugins).
  FakeHomeScreenWidget? homeWidget,
  FakeVoiceInput? voice,

  /// Connection (none by default) and downloaded covers (memory).
  FakeNetworkStatus? network,
  FakeCoverCache? coverCache,
  CoverScanner? coverScanner,
  SuggestionSources? suggestionSources,
  SeriesCatalogSource? seriesCatalog,
  MangaDexCovers? mangaDex,

  /// Series sources (AniList, Comic Vine): none by default, never the network.
  SeriesLookup? seriesLookup,

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
      overrides: [
        appDatabaseProvider.overrideWithValue(db),
        loanRemindersProvider.overrideWithValue(
          reminders ?? FakeLoanReminders(),
        ),
        backupStoreProvider.overrideWithValue(backups ?? MemoryBackupStore()),
        appShortcutsProvider.overrideWithValue(shortcuts ?? FakeAppShortcuts()),
        homeScreenWidgetProvider.overrideWithValue(
          homeWidget ?? FakeHomeScreenWidget(),
        ),
        voiceInputProvider.overrideWithValue(voice ?? FakeVoiceInput()),
        networkStatusProvider.overrideWithValue(network ?? FakeNetworkStatus()),
        coverCacheProvider.overrideWithValue(coverCache ?? FakeCoverCache()),
        // No ML Kit in tests: the manual editor is used unless overridden.
        coverScannerProvider.overrideWithValue(
          coverScanner ?? FakeCoverScanner(),
        ),
        suggestionSourcesProvider.overrideWithValue(
          suggestionSources ?? FakeSuggestionSources(),
        ),
        // No MangaDex in tests unless a test brings its own.
        mangaDexCoversProvider.overrideWithValue(mangaDex),
        seriesCatalogSourceProvider.overrideWithValue(
          seriesCatalog ?? FakeSeriesCatalogSource(),
        ),
        seriesLookupProvider.overrideWithValue(seriesLookup ?? SeriesLookup()),
        ...overrides,
      ],
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
