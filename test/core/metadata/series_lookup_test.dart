import 'package:dupe/core/logging/app_log.dart';
import 'package:dupe/core/metadata/series_lookup.dart';
import 'package:dupe/core/metadata/series_metadata.dart';
import 'package:dupe/features/collection/domain/collection_type.dart';
import 'package:flutter_test/flutter_test.dart';

class _Source implements SeriesMetadataProvider {
  new(this.seriesSource, {this.titles = const [], this.fails = false});

  @override
  final SeriesSource seriesSource;
  final List<String> titles;
  final bool fails;

  @override
  Future<List<SeriesMetadata>> searchSeries(String query) async {
    if (fails) throw SeriesLookupException(seriesSource, 'HTTP 500');
    return [
      for (final t in titles)
        SeriesMetadata(source: seriesSource, sourceId: t, title: t),
    ];
  }
}

void main() {
  setUp(appLog.clear);

  test('manga: AniList then MangaUpdates; one failing is logged', () async {
    final lookup = SeriesLookup(
      anilist: _Source(SeriesSource.anilist, fails: true),
      mangaUpdates: _Source(SeriesSource.mangaUpdates, titles: ['Dreamland']),
    );
    final results = await lookup.search('Dreamland', CollectionType.manga);
    expect(results.single.source, SeriesSource.mangaUpdates);
    expect(appLog.entries, hasLength(1));
    expect(lookup.search('x', CollectionType.bd), completion(isEmpty));
  });

  test('every source failing: the error goes up', () {
    final lookup = SeriesLookup(
      anilist: _Source(SeriesSource.anilist, fails: true),
      mangaUpdates: _Source(SeriesSource.mangaUpdates, fails: true),
    );
    expect(
      lookup.search('Dreamland', CollectionType.manga),
      throwsA(isA<SeriesLookupException>()),
    );
  });
}
