import 'package:dupe/core/metadata/metadata_provider.dart';
import 'package:dupe/core/metadata/metadata_result.dart';
import 'package:dupe/core/metadata/providers/comic_vine/comic_vine_provider.dart';
import 'package:dupe/core/metadata/series_metadata.dart';
import 'package:dupe/core/network/rate_limiter.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../helpers/fake_http.dart';

void main() {
  late FakeHttpAdapter http;
  late ComicVineProvider provider;

  setUp(() {
    http = FakeHttpAdapter();
    provider = ComicVineProvider(
      fakeDio(http),
      apiKey: 'test-key',
      limiter: RateLimiter(Duration.zero),
    );
  });

  test('searches volumes and parses the real response', () async {
    http.on(
      (u) => u.queryParameters['resources'] == 'volume',
      fixture('comic_vine/search_volume_batman.json'),
    );

    final results = await provider.searchSeries('batman');

    final query = http.requests.single.queryParameters;
    expect(query['api_key'], 'test-key');
    expect(query['format'], 'json');
    expect(query['query'], 'batman');
    expect(results, hasLength(10));

    final dc = results.firstWhere((m) => m.publisher == 'DC Comics');
    expect(dc.source, SeriesSource.comicVine);
    expect(dc.sourceId, '796');
    expect(dc.title, 'Batman');
    expect(dc.startYear, 1940);
    expect(dc.totalVolumes, 716);
    expect(dc.description, 'Volume 1.');
    expect(dc.coverUrl, contains('/scale_medium/'));
    expect(dc.siteUrl, startsWith('https://comicvine.gamespot.com/'));
    // deck: null stays null.
    expect(results.first.description, isNull);
  });

  test('searches issues as metadata results', () async {
    http.on(
      (u) => u.queryParameters['resources'] == 'issue',
      fixture('comic_vine/search_issue_batman_3.json'),
    );

    final results = await provider.searchByText('batman 3');

    expect(results, hasLength(10));
    final first = results.first;
    expect(first.source, MetadataSource.comicVine);
    expect(first.sourceId, '664518');
    expect(first.title, 'Batman');
    expect(first.seriesTitle, 'Batman');
    expect(first.volumeNumber, '3');
    expect(first.subtitle, isNull);
    expect(first.publishDate, '2017-07-31');
    expect(first.coverUrl, contains('/scale_medium/'));
    expect(results.last.publishDate, isNull);
  });

  test('has no ISBN index', () async {
    expect(await provider.searchByIsbn('9782365770484'), isNull);
    expect(http.requests, isEmpty);
  });

  test('an error envelope becomes the interface exception', () async {
    // Shape of Comic Vine's answer to an invalid key.
    http.on(
      (u) => true,
      '{"status_code":100,"error":"Invalid API Key","results":[]}',
    );
    expect(provider.searchSeries('x'), throwsA(isA<SeriesLookupException>()));
    expect(provider.searchByText('x'), throwsA(isA<MetadataException>()));
  });

  test('HTTP errors become the interface exception', () async {
    http.on((u) => true, '{}', status: 420);
    expect(provider.searchSeries('x'), throwsA(isA<SeriesLookupException>()));
    expect(provider.searchByText('x'), throwsA(isA<MetadataException>()));
  });
}
