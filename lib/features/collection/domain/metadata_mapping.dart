import 'package:dupe/core/metadata/metadata_result.dart';
import 'package:dupe/features/collection/domain/enums.dart';
import 'package:dupe/features/collection/domain/item.dart';

/// What the add form is prefilled with when coming from an online result.
typedef ItemPrefill = ({MetadataResult metadata, Ownership ownership});

/// Copies external metadata into a new item (empty values are kept).
Item applyMetadata(Item item, ItemPrefill prefill) {
  final m = prefill.metadata;
  final title = m.subtitle == null || m.volumeNumber != null
      ? m.title
      : '${m.title} : ${m.subtitle}';
  return item.copyWith(
    title: title,
    volumeNumber: m.volumeNumber ?? item.volumeNumber,
    isbn13: m.isbn13,
    authors: m.authors.isEmpty ? item.authors : m.authors,
    publisher: m.publisher ?? item.publisher,
    publishDate: m.publishDate,
    pageCount: m.pageCount,
    language: m.language,
    coverUrl: m.coverUrl,
    description: m.description,
    coverPrice: m.coverPrice,
    currency: m.currency ?? item.currency,
    ownership: prefill.ownership,
    source: m.source.name,
    sourceId: m.sourceId,
  );
}
