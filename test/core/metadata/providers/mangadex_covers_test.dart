import 'package:dupe/core/metadata/providers/mangadex/mangadex_covers.dart';
import 'package:dupe/core/network/rate_limiter.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../helpers/fake_http.dart';

void main() {
  late FakeHttpAdapter http;
  late MangaDexCovers mangaDex;

  setUp(() {
    http = FakeHttpAdapter()
      ..on((u) => u.path == '/manga', fixture('mangadex/search_dreamland.json'))
      ..on(
        (u) => u.path == '/cover',
        fixture('mangadex/covers_dreamland.json'),
      );
    mangaDex = MangaDexCovers(
      fakeDio(http),
      limiter: RateLimiter(Duration.zero),
    );
  });

  test('French cover of a volume, by series title (real responses)', () async {
    final url = await mangaDex.frenchCover('Dreamland', '04');

    expect(url, startsWith('https://uploads.mangadex.org/covers/05be3fec-'));
    expect(url, endsWith('.512.jpg'));
    expect(http.requests.first.queryParameters['title'], 'Dreamland');
    expect(http.requests.last.queryParameters['locales[]'], 'fr');
    // The covers of the series are asked once.
    await mangaDex.frenchCover('Dreamland', '5');
    expect(http.requests, hasLength(2));
  });

  test('no cover: unknown volume, special number, other title', () async {
    // Volume 1 only exists as "1.1", "1.2"… (another edition's split).
    expect(await mangaDex.frenchCover('Dreamland', '1'), isNull);
    expect(await mangaDex.frenchCover('Dreamland', 'HS 1'), isNull);
    expect(await mangaDex.frenchCover('Everdark', '4'), isNull);
  });
}
