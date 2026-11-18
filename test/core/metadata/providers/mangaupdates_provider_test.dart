import 'package:dupe/core/metadata/providers/mangaupdates/mangaupdates_provider.dart';
import 'package:dupe/core/metadata/series_metadata.dart';
import 'package:dupe/core/network/rate_limiter.dart';
import 'package:dupe/features/collection/domain/enums.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../helpers/fake_http.dart';

void main() {
  test('a French manga AniList ignores: volumes out so far', () async {
    final http = FakeHttpAdapter()
      ..on(
        (u) => u.path.endsWith('/series/search'),
        fixture('mangaupdates/search_dreamland.json'),
      )
      ..on(
        (u) => u.path.contains('/series/'),
        fixture('mangaupdates/series_dreamland.json'),
      );
    final provider = MangaUpdatesProvider(
      fakeDio(http),
      limiter: RateLimiter(Duration.zero),
    );

    final results = await provider.searchSeries('Dreamland');

    final dreamland = results.first;
    expect(dreamland.source, SeriesSource.mangaUpdates);
    expect(dreamland.title, 'Dreamland');
    expect(dreamland.totalVolumes, 22);
    expect(dreamland.status, PublicationStatus.enCours);
    expect(dreamland.authors, ['Reno Lemaire']);
    // Only the exact title is fetched in full.
    expect(http.requests, hasLength(2));
    expect(results.skip(1).every((r) => r.totalVolumes == null), isTrue);
  });

  test('status text', () {
    expect(
      parseMangaUpdatesStatus('203 Chapters (Ongoing)\n22 Volumes (Ongoing)'),
      (volumes: 22, status: PublicationStatus.enCours),
    );
    expect(parseMangaUpdatesStatus('12 Volumes (Complete)'), (
      volumes: 12,
      status: PublicationStatus.terminee,
    ));
    expect(parseMangaUpdatesStatus(null), (
      volumes: null,
      status: PublicationStatus.inconnue,
    ));
  });
}
