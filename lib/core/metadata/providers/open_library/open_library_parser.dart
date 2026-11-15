import 'package:dupe/core/metadata/metadata_result.dart';
import 'package:dupe/core/utils/isbn.dart';

/// Parses `/api/books?jscmd=data` for one ISBN.
MetadataResult? parseOpenLibraryBook(Map<String, dynamic> json, String isbn13) {
  final data = json['ISBN:$isbn13'] as Map<String, dynamic>?;
  final title = data?['title'] as String?;
  if (data == null || title == null) return null;

  List<String> names(String key) => (data[key] as List<dynamic>? ?? [])
      .cast<Map<String, dynamic>>()
      .map((e) => e['name'] as String)
      .toList();
  final cover = data['cover'] as Map<String, dynamic>? ?? const {};
  final identifiers = data['identifiers'] as Map<String, dynamic>? ?? const {};
  final isbn = (identifiers['isbn_13'] as List<dynamic>?)?.firstOrNull;

  return MetadataResult(
    source: MetadataSource.openLibrary,
    sourceId: data['key'] as String? ?? isbn13,
    title: title,
    subtitle: data['subtitle'] as String?,
    authors: names('authors'),
    publisher: names('publishers').firstOrNull,
    publishDate: data['publish_date'] as String?,
    pageCount: data['number_of_pages'] as int?,
    isbn13: isbn is String ? Isbn.toIsbn13(isbn) : isbn13,
    coverUrl: (cover['large'] ?? cover['medium']) as String?,
  );
}

/// Parses `/search.json` (works, not editions: no reliable ISBN).
List<MetadataResult> parseOpenLibrarySearch(Map<String, dynamic> json) {
  final docs = (json['docs'] as List<dynamic>? ?? [])
      .cast<Map<String, dynamic>>();
  return [
    for (final doc in docs)
      if (doc['title'] case final String title)
        MetadataResult(
          source: MetadataSource.openLibrary,
          sourceId: doc['key'] as String? ?? title,
          title: title,
          authors: (doc['author_name'] as List<dynamic>? ?? []).cast<String>(),
          publishDate: (doc['first_publish_year'] as int?)?.toString(),
          pageCount: doc['number_of_pages_median'] as int?,
          coverUrl: switch (doc['cover_i']) {
            final int id => 'https://covers.openlibrary.org/b/id/$id-L.jpg',
            _ => null,
          },
        ),
  ];
}

/// Cover by ISBN; 404 instead of a blank image when missing.
String openLibraryCoverByIsbn(String isbn13) =>
    'https://covers.openlibrary.org/b/isbn/$isbn13-L.jpg?default=false';
