import 'package:dupe/core/metadata/metadata_result.dart';
import 'package:dupe/features/collection/domain/collection_type.dart';

/// A metadata source (Google Books, Open Library, BnF…).
abstract interface class MetadataProvider {
  MetadataSource get source;

  /// Collection types this source is relevant for.
  Set<CollectionType> get supportedTypes;

  /// Looks up one edition by ISBN-13; null when unknown to the source.
  Future<MetadataResult?> searchByIsbn(String isbn13);

  /// Free-text search (title, author…).
  Future<List<MetadataResult>> searchByText(String query);
}

/// A source failed (network, HTTP error, unparsable response).
class MetadataException implements Exception {
  const new(this.source, this.message);

  final MetadataSource source;
  final String message;

  @override
  String toString() => 'MetadataException(${source.name}): $message';
}
