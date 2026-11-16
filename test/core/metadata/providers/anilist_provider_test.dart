import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:dupe/core/metadata/providers/anilist/anilist_provider.dart';
import 'package:dupe/core/metadata/series_metadata.dart';
import 'package:dupe/core/network/rate_limiter.dart';
import 'package:dupe/features/collection/domain/enums.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../helpers/fake_http.dart';

void main() {
  late FakeHttpAdapter http;
  late AniListProvider provider;
  late Object? sentBody;

  setUp(() {
    http = FakeHttpAdapter();
    final dio = fakeDio(http)
      ..interceptors.add(
        InterceptorsWrapper(
          onRequest: (options, handler) {
            sentBody = options.data;
            handler.next(options);
          },
        ),
      );
    provider = AniListProvider(dio, limiter: RateLimiter(Duration.zero));
  });

  test('searches manga via GraphQL and parses the real response', () async {
    http.on((u) => true, fixture('anilist/search_one_piece.json'));

    final results = await provider.searchSeries('one piece');

    final body = jsonDecode(jsonEncode(sentBody)) as Map<String, dynamic>;
    expect(body['variables'], {'search': 'one piece'});
    expect(body['query'], contains('type: MANGA'));
    expect(results, hasLength(10));

    final onePiece = results.first;
    expect(onePiece.source, SeriesSource.anilist);
    expect(onePiece.sourceId, '30013');
    expect(onePiece.title, 'One Piece');
    expect(onePiece.originalTitle, 'ONE PIECE');
    // Former assistants are not authors.
    expect(onePiece.authors, ['Eiichirou Oda']);
    expect(onePiece.status, PublicationStatus.enCours);
    // Ongoing: AniList has no volume count.
    expect(onePiece.totalVolumes, isNull);
    expect(onePiece.coverUrl, startsWith('https://'));
    expect(onePiece.description, isNot(contains('<')));
  });

  test('a finished spin-off has a volume count and finished status', () async {
    http.on((u) => true, fixture('anilist/search_one_piece.json'));

    final party = (await provider.searchSeries('one piece'))
        .firstWhere((m) => m.sourceId == '102533');

    expect(party.totalVolumes, 7);
    expect(party.status, PublicationStatus.terminee);
    // Translator is not an author; original creator and artist are.
    expect(party.authors, ['Eiichirou Oda', 'Ei Andou']);
  });

  test('HTTP errors become SeriesLookupException', () async {
    http.on((u) => true, '{"errors":[]}', status: 429);
    expect(provider.searchSeries('x'), throwsA(isA<SeriesLookupException>()));
  });

  test(
    'neighbours: recommendations and related manga (real response)',
    () async {
      http.on((u) => true, fixture('anilist/neighbours_vinland.json'));

      final n = (await provider.neighbours(title: 'Vinland Saga'))!;

      final body = jsonDecode(jsonEncode(sentBody)) as Map<String, dynamic>;
      expect(body['variables'], {'search': 'Vinland Saga'});
      expect(n.media.title, 'Vinland Saga');
      expect(n.synonyms, contains('Saga Winlandzka'));
      final berserk = n.recommendations.first;
      expect((berserk.media.title, berserk.votes), ('Berserk', 1621));
      expect(berserk.media.authors, contains('Kentarou Miura'));
      // Anime adaptations are left out; manga spin-offs and one-shots kept.
      expect(n.related.map((r) => r.relation), isNot(contains('ADAPTATION')));
      expect(
        n.related.map((r) => (r.relation, r.format)),
        containsAll([('SPIN_OFF', 'MANGA'), ('OTHER', 'ONE_SHOT')]),
      );
    },
  );

  test('neighbours by id; an unknown manga gives null (HTTP 404)', () async {
    http.on(
      (u) => true,
      jsonEncode({
        'errors': [
          {'message': 'Not Found.', 'status': 404},
        ],
        'data': {'Media': null},
      }),
      status: 404,
    );

    expect(await provider.neighbours(id: 42), isNull);
    final body = jsonDecode(jsonEncode(sentBody)) as Map<String, dynamic>;
    expect(body['variables'], {'id': 42});
  });
}
