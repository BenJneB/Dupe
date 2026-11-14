import 'package:dupe/core/metadata/metadata_provider.dart';
import 'package:dupe/core/metadata/metadata_result.dart';
import 'package:dupe/features/collection/domain/collection_type.dart';

/// In-memory metadata source for tests.
class FakeProvider implements MetadataProvider {
  new(
    this.source, {
    this.isbnResult,
    this.byIsbn = const {},
    this.textResults = const [],
    this.error,
    this.delay,
  });

  @override
  final MetadataSource source;
  final MetadataResult? isbnResult;

  /// Per-ISBN answers; other ISBNs get [isbnResult].
  final Map<String, MetadataResult> byIsbn;
  final List<MetadataResult> textResults;
  final Exception? error;
  final Duration? delay;
  int calls = 0;

  @override
  Set<CollectionType> get supportedTypes => CollectionType.values.toSet();

  Future<T> _answer<T>(T value) async {
    calls++;
    if (delay != null) await Future<void>.delayed(delay!);
    if (error != null) throw error!;
    return value;
  }

  @override
  Future<MetadataResult?> searchByIsbn(String isbn13) =>
      _answer(byIsbn[isbn13] ?? isbnResult);

  @override
  Future<List<MetadataResult>> searchByText(String query) =>
      _answer(textResults);
}
