import 'dart:io';

import 'package:dupe/core/database/app_database.dart';
import 'package:dupe/core/database/local_stores.dart';
import 'package:dupe/core/metadata/metadata_aggregator.dart';
import 'package:dupe/core/metadata/metadata_result.dart';
import 'package:dupe/features/collection/domain/collection_type.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/fake_metadata.dart';
import '../../helpers/fake_sources.dart';

void main() {
  late AppDatabase db;
  late DateTime now;
  late DriftResponseStore store;

  setUp(() {
    db = AppDatabase.memory();
    now = DateTime.utc(2026, 11, 14);
    store = DriftResponseStore(db, now: () => now);
  });
  tearDown(() => db.close());

  /// A fresh aggregator (empty memory cache), as after an app restart.
  MetadataAggregator restart(FakeProvider source) =>
      MetadataAggregator(providers: [source], store: store, now: () => now);

  Future<void> settle() => Future<void>.delayed(Duration.zero);

  test('answers survive a restart without calling the source', () async {
    final online = FakeProvider(MetadataSource.bnf, isbnResult: duneResult);
    await restart(online).lookupIsbn(duneIsbn, CollectionType.livre);
    await settle();

    final again = FakeProvider(MetadataSource.bnf, isbnResult: duneResult);
    final lookup = await restart(again)
        .lookupIsbn(duneIsbn, CollectionType.livre);

    expect(again.calls, 0);
    expect(lookup.results.single, duneResult);
  });

  test('a stale answer is refreshed, or used when the source fails', () async {
    await restart(FakeProvider(MetadataSource.bnf, isbnResult: duneResult))
        .lookupIsbn(duneIsbn, CollectionType.livre);
    await settle();
    now = now.add(const Duration(days: 90));

    final offline = FakeProvider(
      MetadataSource.bnf,
      error: const SocketException('offline'),
    );
    final lookup = await restart(offline)
        .lookupIsbn(duneIsbn, CollectionType.livre);
    expect(offline.calls, 1);
    expect(lookup.merged?.title, 'Dune');
    expect(lookup.failed, isEmpty);

    final online = FakeProvider(
      MetadataSource.bnf,
      isbnResult: duneResult.copyWith(title: 'Dune (nouvelle édition)'),
    );
    final refreshed = await restart(online)
        .lookupIsbn(duneIsbn, CollectionType.livre);
    expect(refreshed.merged?.title, 'Dune (nouvelle édition)');
  });

  test('"not found" is cached for a shorter time', () async {
    await restart(FakeProvider(MetadataSource.bnf))
        .lookupIsbn(duneIsbn, CollectionType.livre);
    await settle();

    now = now.add(const Duration(days: 1));
    final tomorrow = FakeProvider(MetadataSource.bnf, isbnResult: duneResult);
    await restart(tomorrow).lookupIsbn(duneIsbn, CollectionType.livre);
    expect(tomorrow.calls, 0);

    now = now.add(const Duration(days: 7));
    final nextWeek = FakeProvider(MetadataSource.bnf, isbnResult: duneResult);
    final lookup = await restart(nextWeek)
        .lookupIsbn(duneIsbn, CollectionType.livre);
    expect(nextWeek.calls, 1);
    expect(lookup.merged?.title, 'Dune');
  });

  test('text searches are cached too', () async {
    await restart(FakeProvider(MetadataSource.bnf, textResults: [duneResult]))
        .searchText('Dune', CollectionType.livre);
    await settle();

    final again = FakeProvider(MetadataSource.bnf);
    final search = await restart(again)
        .searchText('dune ', CollectionType.livre);
    expect(again.calls, 0);
    expect(search.results.single.isbn13, duneIsbn);
  });
}
