import 'package:dupe/features/collection/domain/collection_type.dart';
import 'package:dupe/features/search/data/search_repository.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../helpers/test_repositories.dart';

void main() {
  late TestEnv env;
  late SearchRepository search;

  setUp(() async {
    env = TestEnv();
    search = SearchRepository(env.db);
    final series = env.repo
        .newSeries(CollectionType.bd)
        .copyWith(title: "L'Épée de cristal", authors: ['Crisse']);
    await env.repo.saveSeries(series);
    await env.repo.saveItem(
      env.repo
          .newItem(CollectionType.livre)
          .copyWith(title: 'Dune', isbn13: '9782266320481'),
    );
  });
  tearDown(() => env.dispose());

  test('is case and accent insensitive', () async {
    final results = await search.search('epee');
    expect(results.series.single.title, "L'Épée de cristal");
  });

  test('matches authors', () async {
    final results = await search.search('crisse');
    expect(results.series, hasLength(1));
  });

  test('matches ISBN typed with dashes', () async {
    final results = await search.search('978-2-266-32048-1');
    expect(results.items.single.title, 'Dune');
  });

  test('ignores deleted rows and empty queries', () async {
    final item = (await search.search('dune')).items.single;
    await env.repo.deleteItem(item.id);
    expect((await search.search('dune')).items, isEmpty);
    expect((await search.search('  ')).series, isEmpty);
  });
}
