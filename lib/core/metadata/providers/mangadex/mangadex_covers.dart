import 'package:dio/dio.dart';
import 'package:dupe/core/network/rate_limiter.dart';
import 'package:dupe/features/collection/domain/series_matching.dart';

/// MangaDex (no key, User-Agent required): covers per volume, often of the
/// French edition, for the manga the other sources have no image of
/// (PLAN_V4 phase 32). Docs: https://api.mangadex.org/docs/
class MangaDexCovers {
  new(this._dio, {RateLimiter? limiter})
    : _limiter = limiter ?? RateLimiter(const Duration(milliseconds: 250));

  static const _api = 'https://api.mangadex.org';
  static const _uploads = 'https://uploads.mangadex.org/covers';

  final Dio _dio;
  final RateLimiter _limiter;

  /// Covers of a manga, by id: `volume number -> file` (French ones only).
  final _covers = <String, Map<int, String>>{};
  final _ids = <String, String?>{};

  /// The French cover of volume [volume] of [seriesTitle], 512 px wide;
  /// null when MangaDex has none (or another series of that name).
  Future<String?> frenchCover(String seriesTitle, String volume) async {
    final number = int.tryParse(volume.trim());
    if (number == null) return null;
    // Network errors go up to the caller (logged, next book).
    final key = normalizeTitle(seriesTitle);
    final id = _ids.containsKey(key)
        ? _ids[key]
        : _ids[key] = await _findManga(seriesTitle);
    if (id == null) return null;
    final files = _covers[id] ??= await _frenchCovers(id);
    final file = files[number];
    return file == null ? null : '$_uploads/$id/$file.512.jpg';
  }

  /// The manga titled exactly [title] (any language, alternative titles).
  Future<String?> _findManga(String title) async {
    final json = await _get('/manga', {'title': title, 'limit': '10'});
    final wanted = normalizeTitle(title);
    for (final m in (json['data'] as List<dynamic>? ?? const [])) {
      final manga = m as Map<String, dynamic>;
      final attributes = manga['attributes'] as Map<String, dynamic>;
      final titles = [
        ...(attributes['title'] as Map<String, dynamic>).values,
        for (final alt in attributes['altTitles'] as List<dynamic>? ?? const [])
          ...(alt as Map<String, dynamic>).values,
      ].whereType<String>();
      if (titles.map(normalizeTitle).contains(wanted)) {
        return manga['id'] as String;
      }
    }
    return null;
  }

  Future<Map<int, String>> _frenchCovers(String id) async {
    final covers = <int, String>{};
    var offset = 0;
    while (true) {
      final json = await _get('/cover', {
        'manga[]': id,
        'locales[]': 'fr',
        'limit': '100',
        'offset': '$offset',
      });
      final data = json['data'] as List<dynamic>? ?? const [];
      for (final c in data) {
        final a =
            (c as Map<String, dynamic>)['attributes'] as Map<String, dynamic>;
        final n = int.tryParse('${a['volume']}');
        if (n != null && a['locale'] == 'fr') {
          covers.putIfAbsent(n, () => a['fileName'] as String);
        }
      }
      offset += data.length;
      if (data.isEmpty || offset >= (json['total'] as int? ?? 0)) break;
    }
    return covers;
  }

  Future<Map<String, dynamic>> _get(String path, Map<String, String> query) =>
      _limiter.run(() async {
        final r = await _dio.get<Map<String, dynamic>>(
          '$_api$path',
          queryParameters: query,
        );
        return r.data ?? const {};
      });
}
