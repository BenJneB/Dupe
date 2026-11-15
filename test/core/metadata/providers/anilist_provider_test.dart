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
}
