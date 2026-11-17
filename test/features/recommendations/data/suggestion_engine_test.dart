import 'dart:convert';
import 'dart:io';

import 'package:dupe/core/logging/app_log.dart';
import 'package:dupe/core/metadata/metadata_result.dart';
import 'package:dupe/core/metadata/providers/anilist/anilist_parser.dart';
import 'package:dupe/core/metadata/providers/bnf/unimarc_parser.dart';
import 'package:dupe/features/collection/domain/collection_type.dart';
import 'package:dupe/features/collection/domain/enums.dart';
import 'package:dupe/features/collection/domain/item.dart';
import 'package:dupe/features/collection/domain/series.dart';
import 'package:dupe/features/recommendations/data/suggestion_engine.dart';
import 'package:dupe/features/recommendations/domain/suggestion.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../helpers/collection_builders.dart' as ranking;
import '../../../helpers/fake_http.dart';
import '../../../helpers/fake_suggestion_sources.dart';

final AniListNeighbours vinland = parseAniListNeighbours(
  jsonDecode(fixture('anilist/neighbours_vinland.json'))
      as Map<String, dynamic>,
)!;
final List<MetadataResult> larcenet = parseUnimarcResponse(
  fixture('bnf/author_larcenet.xml'),
);

final List<Item> items = [
  ranking.item(
    'Le combat ordinaire',
    authors: ['Manu Larcenet'],
    seriesId: 'co',
    reading: ReadingStatus.lu,
    rating: 5,
  ),
  ranking.item('Vinland Saga', seriesId: 'vs', type: CollectionType.manga),
  ranking.item('Vinland Saga', seriesId: 'vs', type: CollectionType.manga),
  // Already owned: never suggested, even if AniList recommends it.
  ranking.item('Berserk', seriesId: 'be', type: CollectionType.manga),
];
final List<Series> series = [
  ranking.series('co', 'Le combat ordinaire', type: CollectionType.bd),
  ranking.series('vs', 'Vinland Saga'),
  ranking.series('be', 'Berserk'),
];

void main() {
  setUp(appLog.clear);

  test(
    'other works of the author and manga neighbours, with reasons',
    () async {
      final sources = FakeSuggestionSources(
        byAuthor: {'Manu Larcenet': larcenet},
        byTitle: {'Vinland Saga': vinland},
      );
      final progress = <(int, int)>[];

      final list = await SuggestionEngine(sources).compute(
        items: items,
        series: series,
        onProgress: (d, t) => progress.add((d, t)),
      );

      final byTitle = {for (final s in list) s.title: s};
      expect(
        byTitle.keys,
        containsAll(['Blast', 'Vagabond', 'Animalland Saga']),
      );
      expect(
        byTitle.keys,
        isNot(anyOf(contains('Le combat ordinaire'), contains('Berserk'))),
      );
      // A one-shot "OTHER" relation is not a sequel.
      expect(byTitle.keys, isNot(contains('Sayonara ga Chikai no de')));

      final blast = byTitle['Blast']!;
      expect(blast.reason.kind, SuggestionKind.sameAuthor);
      expect((blast.reason.label, blast.reason.count), ('Manu Larcenet', 1));
      expect((blast.type, blast.seriesTitle), (CollectionType.bd, 'Blast'));
      final vagabond = byTitle['Vagabond']!;
      expect(vagabond.reason.kind, SuggestionKind.community);
      expect((vagabond.reason.label, vagabond.votes), ('Vinland Saga', 802));
      expect(byTitle['Animalland Saga']!.reason.kind, SuggestionKind.related);
      expect(progress, [(1, 3), (2, 3), (3, 3)]);
    },
  );

  test('a homonym found by title is ignored', () async {
    final list = await SuggestionEngine(
      FakeSuggestionSources(byTitle: {'Berserk': vinland}),
    ).compute(items: items, series: series);
    expect(list, isEmpty);
  });

  test('a failing source is logged, the others still answer', () async {
    final sources = FakeSuggestionSources(
      byTitle: {'Vinland Saga': vinland},
      error: const SocketException('offline'),
    );
    final list = await SuggestionEngine(sources)
        .compute(items: items, series: series);
    expect(list, isNotEmpty);
    expect(appLog.entries.single.source, 'suggestions');
  });
}
