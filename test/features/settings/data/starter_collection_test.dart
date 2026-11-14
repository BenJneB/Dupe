import 'package:dupe/features/collection/domain/collection_entry.dart';
import 'package:dupe/features/collection/domain/collection_type.dart';
import 'package:dupe/features/settings/data/starter_collection.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../helpers/test_repositories.dart';

void main() {
  late TestEnv env;

  setUp(() => env = TestEnv());
  tearDown(() => env.dispose());

  test('seeds every type once and is idempotent', () async {
    // 5 series + 7 standalone books.
    expect(await seedStarterCollection(env.repo), 12);
    expect(await seedStarterCollection(env.repo), 0);

    final mangas = await env.repo.watchEntries(CollectionType.manga).first;
    final onePiece = mangas.whereType<SeriesEntry>().singleWhere(
      (e) => e.title == 'One Piece',
    );
    expect(onePiece.ownedCount, 113);

    final books = await env.repo.watchEntries(CollectionType.livre).first;
    expect(books.whereType<ItemEntry>(), hasLength(7));
    final ants = books.whereType<SeriesEntry>().single;
    final items = await env.repo.watchSeriesItems(ants.series.id).first;
    expect(items.map((i) => i.title), [
      'Les Fourmis',
      'Le Jour des fourmis',
      'La Révolution des fourmis',
    ]);
  });
}
