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

  Future<List<MetadataResult>> _query(String cql, {int max = 20}) async {
    try {
      final response = await _limiter.run(
        () => _dio.get<String>(
          _endpoint,
          queryParameters: {
            'version': '1.2',
            'operation': 'searchRetrieve',
            'recordSchema': 'unimarcXchange',
            'maximumRecords': '$max',
            'query': cql,
          },
          options: Options(responseType: ResponseType.plain),
        ),
      );
      return parseUnimarcResponse(response.data ?? '');
    } on DioException catch (e) {
      throw MetadataException(source, e.message ?? e.type.name);
    } on FormatException catch (e) {
      throw MetadataException(source, e.message);
    }
  }
}
