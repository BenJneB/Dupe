import 'package:dupe/core/database/app_database.dart';
import 'package:dupe/core/database/database_provider.dart';
import 'package:dupe/core/database/local_stores.dart';
import 'package:dupe/core/logging/app_log.dart';
import 'package:dupe/core/metadata/api_keys.dart';
import 'package:dupe/core/metadata/metadata_providers.dart';
import 'package:dupe/core/metadata/source_settings.dart';
import 'package:dupe/features/backup/data/json_backup.dart';
import 'package:dupe/features/collection/domain/collection_type.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/fake_sync_remote.dart';
import '../../helpers/sync_device.dart';

/// Phase 15: keys entered in the app, never synced, exported or logged.
void main() {
  const key = 'cv-test-key-0123456789';
  late AppDatabase db;

  setUp(() => db = AppDatabase.memory());
  tearDown(() => db.close());

  ProviderContainer container() {
    final c = ProviderContainer(
      overrides: [appDatabaseProvider.overrideWithValue(db)],
    );
    addTearDown(c.dispose);
    return c;
  }

  test('an entered key wins over the built-in one', () {
    const builtIn = {SourceId.googleBooks: 'from-env', SourceId.comicVine: ''};
    expect(effectiveApiKeys(const {}, builtIn), builtIn);
    expect(effectiveApiKeys(const {SourceId.googleBooks: 'typed'}, builtIn), {
      SourceId.googleBooks: 'typed',
      SourceId.comicVine: '',
    });
    final keys = effectiveApiKeys(const {}, builtIn);
    expect(sourceHasKey(SourceId.googleBooks, keys), isTrue);
    expect(sourceHasKey(SourceId.comicVine, keys), isFalse);
    expect(sourceHasKey(SourceId.bnf, keys), isTrue);
  });

  test(
    'saving a key turns the source on without restart, and persists',
    () async {
      final c = container();
      await c.read(savedApiKeysProvider.future);
      expect(
        c.read(seriesLookupProvider).providerFor(CollectionType.comic),
        isNull,
      );

      await c
          .read(savedApiKeysProvider.notifier)
          .save(SourceId.comicVine, ' $key ');
      expect(
        c.read(seriesLookupProvider).providerFor(CollectionType.comic),
        isNotNull,
      );

      // After a restart.
      final again = container();
      expect(await again.read(savedApiKeysProvider.future), {
        SourceId.comicVine: key,
      });
      // Removing it goes back to the built-in key (none in tests).
      await again
          .read(savedApiKeysProvider.notifier)
          .save(SourceId.comicVine, '');
      expect(again.read(apiKeysProvider)[SourceId.comicVine], isEmpty);
    },
  );

  test('the key is in no backup and never reaches Supabase', () async {
    final remote = FakeSyncRemote();
    final device = Device(remote);
    addTearDown(device.dispose);
    await AppSettingsStore(device.db)
        .set(SavedApiKeys.settingKey(SourceId.comicVine), key);
    await device.repo.saveItem(
      device.repo.newItem(CollectionType.comic).copyWith(title: 'Batman'),
    );

    final backup = await JsonBackup(device.db).export(now: device.now);
    expect(backup, contains('Batman'));
    expect(backup, isNot(contains(key)));

    await device.sync();
    expect(remote.tables['items'], hasLength(1));
    expect('${remote.tables}', isNot(contains(key)));
  });

  test('the journal never shows a key', () async {
    final c = container();
    await c.read(savedApiKeysProvider.notifier).save(SourceId.comicVine, key);
    appLog
      ..warning('metadata', 'GET /api/search/?api_key=$key&query=x failed')
      ..error('cv', StateError('bad key $key'));
    final last = appLog.entries.reversed.take(2).map((e) => e.message);
    expect(last.join(), isNot(contains(key)));
    expect(last.first, contains('bad key ***'));

    // Any key-looking URL parameter, even unknown values.
    appLog.info('net', 'https://x.org/v1?q=1&key=SOMETHINGELSE42&a=2');
    expect(appLog.entries.last.message, 'https://x.org/v1?q=1&key=***&a=2');
  });
}
