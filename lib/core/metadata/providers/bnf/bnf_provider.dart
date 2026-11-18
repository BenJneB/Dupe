import 'package:dio/dio.dart';
import 'package:dupe/core/metadata/metadata_provider.dart';
import 'package:dupe/core/metadata/metadata_result.dart';
import 'package:dupe/core/metadata/providers/bnf/unimarc_parser.dart';
import 'package:dupe/core/network/rate_limiter.dart';
import 'package:dupe/features/collection/domain/collection_type.dart';

/// BnF general catalogue, SRU API (no key). Best source for French books,
/// BD and manga: precise titles, volume numbers, publisher price.
/// Docs: https://api.bnf.fr/fr/api-sru-catalogue-general
class BnfProvider implements MetadataProvider {
  new(this._dio, {RateLimiter? limiter})
    : _limiter = limiter ?? RateLimiter(const Duration(milliseconds: 500));

  static const _endpoint = 'https://catalogue.bnf.fr/api/SRU';

  final Dio _dio;
  final RateLimiter _limiter;

  @override
  MetadataSource get source => MetadataSource.bnf;

  @override
  Set<CollectionType> get supportedTypes => {
    CollectionType.livre,
    CollectionType.bd,
    CollectionType.manga,
    CollectionType.comic,
  };

  @override
  Future<MetadataResult?> searchByIsbn(String isbn13) async =>
      (await _query('bib.isbn adj "$isbn13"', max: 1)).firstOrNull;

  @override
  Future<List<MetadataResult>> searchByText(String query) {
    final cleaned = query.replaceAll('"', ' ').trim();
    // doctype "a" = printed text.
    return _query('bib.anywhere all "$cleaned" and bib.doctype any "a"');
  }

  /// Printed works of [author] ("Manu Larcenet"), at most [max] records
  /// (suggestions, PLAN_V4 phase 30).
  Future<List<MetadataResult>> searchByAuthor(String author, {int max = 50}) {
    final cleaned = author.replaceAll('"', ' ').trim();
    return _query(
      'bib.author all "$cleaned" and bib.doctype any "a"',
      max: max,
    );
  }

  /// Every printed record titled [title] (volumes of a series, PLAN_V4
  /// phase 37), page after page (50 records each, at most [maxPages]).
  Future<List<MetadataResult>> searchSeriesVolumes(
    String title, {
    int maxPages = 6,
  }) async {
    final cleaned = title.replaceAll('"', ' ').trim();
    final cql = 'bib.title all "$cleaned" and bib.doctype any "a"';
    final all = <MetadataResult>[];
    int? start = 1;
    for (var page = 0; page < maxPages && start != null; page++) {
      final (:records, :next) = await _page(cql, max: 50, start: start);
      all.addAll(records);
      start = next;
    }
    return all;
  }

  Future<List<MetadataResult>> _query(String cql, {int max = 20}) async =>
      (await _page(cql, max: max)).records;

  /// One SRU page, with the position of the following one (`next`), if any.
  Future<({List<MetadataResult> records, int? next})> _page(
    String cql, {
    required int max,
    int start = 1,
  }) async {
    try {
      final response = await _limiter.run(
        () => _dio.get<String>(
          _endpoint,
          queryParameters: {
            'version': '1.2',
            'operation': 'searchRetrieve',
            'recordSchema': 'unimarcXchange',
            'maximumRecords': '$max',
            if (start > 1) 'startRecord': '$start',
            'query': cql,
          },
          options: Options(responseType: ResponseType.plain),
        ),
      );
      final xml = response.data ?? '';
      final next = RegExp(r'<srw:nextRecordPosition>(\d+)<')
          .firstMatch(xml)
          ?.group(1);
      return (
        records: parseUnimarcResponse(xml),
        next: next == null ? null : int.parse(next),
      );
    } on DioException catch (e) {
      throw MetadataException(source, e.message ?? e.type.name);
    } on FormatException catch (e) {
      throw MetadataException(source, e.message);
    }
  }
}
