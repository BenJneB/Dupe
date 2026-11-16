import 'package:dupe/core/metadata/metadata_result.dart';
import 'package:dupe/features/collection/domain/enums.dart';
import 'package:dupe/features/collection/domain/item.dart';
import 'package:dupe/features/collection/domain/series_matching.dart';

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

/// A volume created empty (grid, "Ajouter des tomes", previous volumes)
/// once its online record is known (store scan): fills only what is still
/// empty, never what the user typed. The title is replaced only when it is
/// the series title and the record has the volume's own title.
Item fillBlanks(Item item, MetadataResult m, {required String seriesTitle}) {
  bool blank(String? v) => v == null || v.trim().isEmpty;
  final ownTitle =
      normalizeTitle(item.title) == normalizeTitle(seriesTitle) &&
      normalizeTitle(m.title) != normalizeTitle(seriesTitle) &&
      m.title.trim().isNotEmpty;
  return item.copyWith(
    title: ownTitle ? m.title : item.title,
    isbn13: item.isbn13 ?? m.isbn13,
    authors: item.authors.isEmpty ? m.authors : item.authors,
    publisher: blank(item.publisher) ? m.publisher : item.publisher,
    publishDate: blank(item.publishDate) ? m.publishDate : item.publishDate,
    pageCount: item.pageCount ?? m.pageCount,
    language: blank(item.language) ? m.language : item.language,
    coverUrl: blank(item.coverUrl) ? m.coverUrl : item.coverUrl,
    description: blank(item.description) ? m.description : item.description,
    coverPrice: item.coverPrice ?? m.coverPrice,
    currency: item.coverPrice == null && m.coverPrice != null
        ? m.currency ?? item.currency
        : item.currency,
  );
}
