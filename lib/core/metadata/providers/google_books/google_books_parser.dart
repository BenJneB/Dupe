import 'package:dupe/core/metadata/metadata_result.dart';
import 'package:dupe/core/utils/isbn.dart';

/// Parses a `books#volumes` response.
List<MetadataResult> parseGoogleBooksVolumes(Map<String, dynamic> json) {
  final items = json['items'] as List<dynamic>? ?? const [];
  return [
    for (final item in items.cast<Map<String, dynamic>>()) ?_parseVolume(item),
  ];
}

MetadataResult? _parseVolume(Map<String, dynamic> item) {
  final info = item['volumeInfo'] as Map<String, dynamic>? ?? const {};
  final title = info['title'] as String?;
  if (title == null) return null;

  final identifiers = (info['industryIdentifiers'] as List<dynamic>? ?? [])
      .cast<Map<String, dynamic>>();
  // Valid ones only: an invalid ISBN_13 falls back on the ISBN_10.
  String? isbnOf(String type) => identifiers
      .where((i) => i['type'] == type)
      .map((i) => Isbn.toIsbn13(i['identifier'] as String))
      .nonNulls
      .firstOrNull;
  final isbn = isbnOf('ISBN_13') ?? isbnOf('ISBN_10');

  final images = info['imageLinks'] as Map<String, dynamic>? ?? const {};
  final cover = (images['thumbnail'] ?? images['smallThumbnail']) as String?;

  final price =
      (item['saleInfo'] as Map<String, dynamic>?)?['listPrice']
          as Map<String, dynamic>?;

  return MetadataResult(
    source: MetadataSource.googleBooks,
    sourceId: item['id'] as String? ?? title,
    title: title,
    subtitle: info['subtitle'] as String?,
    authors: (info['authors'] as List<dynamic>? ?? []).cast<String>(),
    publisher: info['publisher'] as String?,
    publishDate: info['publishedDate'] as String?,
    pageCount: info['pageCount'] as int?,
    language: info['language'] as String?,
    isbn13: isbn,
    // Google returns http URLs with a page curl; https and flat look better.
    coverUrl: cover
        ?.replaceFirst('http://', 'https://')
        .replaceAll('&edge=curl', ''),
    description: info['description'] as String?,
    coverPrice: (price?['amount'] as num?)?.toDouble(),
    currency: price?['currencyCode'] as String?,
  );
}
