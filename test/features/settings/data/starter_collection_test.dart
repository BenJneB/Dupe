import 'package:dupe/core/database/local_stores.dart';
import 'package:dupe/features/collection/domain/collection_entry.dart';
import 'package:dupe/features/collection/domain/collection_type.dart';
import 'package:dupe/features/settings/data/starter_collection.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../helpers/test_repositories.dart';

void main() {
  late TestEnv env;
  late AppSettingsStore settings;

  setUp(() {
    env = TestEnv();
    settings = AppSettingsStore(env.db);
  });
  tearDown(() => env.dispose());

  Future<int> seed() => seedStarterCollection(env.repo, settings);

  Future<SeriesEntry> seriesEntry(CollectionType type, String title) async =>
      (await env.repo.watchEntries(type).first)
          .whereType<SeriesEntry>()
          .singleWhere((e) => e.title == title);

  test('seeds every type once and is idempotent', () async {
    expect(await seed(), greaterThan(0));
    expect(await seed(), 0);

    final mangas = await env.repo.watchEntries(CollectionType.manga).first;
    expect(mangas.map((e) => e.title), ['Dreamland']);
    final dreamland = await seriesEntry(CollectionType.manga, 'Dreamland');
    // 24 volumes, 1 to 10 also in the 2022 edition.
    expect(dreamland.itemCount, 34);
    // The list shows volumes, not copies: "24/24 tomes".
    expect(dreamland.ownedCount, 24);
    final items = await env.repo.listSeriesItems(dreamland.series.id);
    expect(items.every((i) => i.isbn13 != null), isTrue);
    final volume1 = items.where((i) => i.volumeNumber == '1');
    expect(volume1.map((i) => i.isbn13), {'9782845995581', '9782811666644'});
    expect(volume1.map((i) => i.edition), {
      'Première édition',
      'Nouvelle édition (2022)',
    });

    final books = await env.repo.watchEntries(CollectionType.livre).first;
    expect(books.whereType<ItemEntry>(), hasLength(7));
    final ants = books.whereType<SeriesEntry>().single;
    final volumes = await env.repo.listSeriesItems(ants.series.id);
    expect(volumes.map((i) => i.title).toSet(), {
      'Les Fourmis',
      'Le Jour des fourmis',
      'La Révolution des fourmis',
    });
  });

  test('upgrades a collection seeded by the previous version', () async {
    // Previous starter collection: One Piece 1-113 and Dreamland 1-24,
    // without ISBN.
    for (final (title, count) in [('One Piece', 113), ('Dreamland', 24)]) {
      final series = env.repo
          .newSeries(CollectionType.manga)
          .copyWith(title: title, publisher: 'x');
      await env.repo.saveSeries(series);
      await env.repo.addVolumeRange(series, from: 1, to: count);
    }

    await seed();

    final mangas = await env.repo.watchEntries(CollectionType.manga).first;
    expect(mangas.map((e) => e.title), ['Dreamland']);
    final dreamland = await seriesEntry(CollectionType.manga, 'Dreamland');
    final items = await env.repo.listSeriesItems(dreamland.series.id);
    // The 24 existing volumes got their ISBN, 10 copies were added.
    expect(items, hasLength(34));
    expect(items.where((i) => i.isbn13 == null), isEmpty);

    // A One Piece added by hand later is not deleted again.
    final again = env.repo
        .newSeries(CollectionType.manga)
        .copyWith(title: 'One Piece');
    await env.repo.saveSeries(again);
    expect(await seed(), 0);
    expect(await env.repo.getSeries(again.id), isNotNull);
  });
}
