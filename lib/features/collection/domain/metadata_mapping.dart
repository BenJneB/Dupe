import 'package:dupe/core/metadata/metadata_result.dart';
import 'package:dupe/features/collection/domain/enums.dart';
import 'package:dupe/features/collection/domain/item.dart';
import 'package:dupe/features/collection/domain/series_matching.dart';

/// What the add form is prefilled with when coming from an online result.
typedef ItemPrefill = ({MetadataResult metadata, Ownership ownership});

/// The volume's own title in [m], for a volume of a series ([seriesTitle],
/// else the series the record names): its title when it is not the series
/// title (BnF: « Les renforts maléfiques » in « Kaamelott »), its subtitle
/// (Comic Vine issue name, BnF 200 $e/$i, Google), or both. Null for a
/// standalone book, or a volume known only by its number.
String? volumeTitleOf(MetadataResult m, {String? seriesTitle}) {
  final series = seriesTitle ?? m.seriesTitle;
  if (series == null && m.volumeNumber == null) return null;
  final title = m.title.trim();
  final own =
      series != null &&
          title.isNotEmpty &&
          normalizeTitle(title) != normalizeTitle(series)
      ? title
      : null;
  final subtitle = m.subtitle?.trim();
  // A subtitle repeating the series or the title says nothing (BnF 200 $i
  // "Jupiter's Legacy" in « Requiem (II), Finale »).
  final sub =
      subtitle == null ||
          subtitle.isEmpty ||
          (series != null &&
              normalizeTitle(subtitle) == normalizeTitle(series)) ||
          normalizeTitle(subtitle) == normalizeTitle(title)
      ? null
      : subtitle;
  if (own != null && sub != null) return '$own : $sub';
  return own ?? sub;
}

/// Copies external metadata into a new item (empty values are kept);
/// [seriesTitle]: the series the item is filed in, if any.
Item applyMetadata(Item item, ItemPrefill prefill, {String? seriesTitle}) {
  final m = prefill.metadata;
  final title = m.subtitle == null || m.volumeNumber != null
      ? m.title
      : '${m.title} : ${m.subtitle}';
  return item.copyWith(
    title: title,
    volumeNumber: m.volumeNumber ?? item.volumeNumber,
    volumeTitle: volumeTitleOf(m, seriesTitle: seriesTitle),
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
/// empty, never what the user typed (the volume's own title included).
Item fillBlanks(Item item, MetadataResult m, {required String seriesTitle}) {
  bool blank(String? v) => v == null || v.trim().isEmpty;
  return item.copyWith(
    volumeTitle: blank(item.volumeTitle)
        ? volumeTitleOf(m, seriesTitle: seriesTitle)
        : item.volumeTitle,
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
