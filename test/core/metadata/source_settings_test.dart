import 'package:dupe/core/database/app_database.dart';
import 'package:dupe/core/database/database_provider.dart';
import 'package:dupe/core/metadata/metadata_providers.dart';
import 'package:dupe/core/metadata/source_settings.dart';
import 'package:dupe/features/collection/domain/collection_type.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
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

  test('a turned-off source is persisted and no longer used', () async {
    final first = container();
    expect(await first.read(disabledSourcesProvider.future), isEmpty);
    expect(
      first.read(seriesLookupProvider).providerFor(CollectionType.manga),
      isNotNull,
    );

    await first
        .read(disabledSourcesProvider.notifier)
        .setEnabled(SourceId.anilist, enabled: false);
    expect(
      first.read(seriesLookupProvider).providerFor(CollectionType.manga),
      isNull,
    );

    // After a restart.
    final second = container();
    expect(await second.read(disabledSourcesProvider.future), {
      SourceId.anilist,
    });

    await second
        .read(disabledSourcesProvider.notifier)
        .setEnabled(SourceId.anilist, enabled: true);
    expect(await container().read(disabledSourcesProvider.future), isEmpty);
  });
}
