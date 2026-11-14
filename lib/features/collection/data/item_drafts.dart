import 'package:dupe/features/collection/data/collection_repository.dart';
import 'package:dupe/features/collection/domain/collection_type.dart';
import 'package:dupe/features/collection/domain/item.dart';
import 'package:dupe/features/collection/domain/metadata_mapping.dart';
import 'package:dupe/features/collection/domain/series_attachment.dart';
import 'package:dupe/features/collection/domain/series_matching.dart';

typedef ItemDraft = ({Item item, SeriesAttachment attachment});

/// Item to edit, or new item draft: attached to [seriesId] when given, or to
/// the series matching the online result [prefill] (auto-attach).
Future<ItemDraft?> loadItemDraft(
  CollectionRepository repo, {
  required CollectionType type,
  String? itemId,
  String? seriesId,
  String? volumeNumber,
  ItemPrefill? prefill,
}) async {
  if (itemId != null) {
    final item = await repo.getItem(itemId);
    return item == null
        ? null
        : (item: item, attachment: SeriesAttachment.none);
  }
  var series = seriesId == null ? null : await repo.getSeries(seriesId);
  var attachment = SeriesAttachment.none;
  if (prefill != null && series == null) {
    final metadata = prefill.metadata;
    series = findMatchingSeries(
      metadata,
      await repo.listSeries(),
      preferredType: type,
    );
    final candidates = seriesTitleCandidates(metadata);
    attachment = series != null
        ? SeriesAttachment(series: series)
        : metadata.volumeNumber != null && candidates.isNotEmpty
        ? SeriesAttachment(newSeriesTitle: candidates.first)
        : SeriesAttachment.none;
  }
  // A matched series dictates the type (scanned from another tab).
  final draft = repo.newItem(
    series?.type ?? type,
    series: series,
    volumeNumber: volumeNumber,
  );
  return (
    item: prefill == null ? draft : applyMetadata(draft, prefill),
    attachment: attachment,
  );
}

/// Creates the proposed series if needed and links [item] to it.
Future<Item> applyAttachment(
  CollectionRepository repo,
  Item item,
  SeriesAttachment attachment,
) async {
  final title = attachment.newSeriesTitle;
  if (title == null || !attachment.createNew || item.seriesId != null) {
    return item;
  }
  final series = repo
      .newSeries(item.type)
      .copyWith(title: title, authors: item.authors, publisher: item.publisher);
  await repo.saveSeries(series);
  return item.copyWith(seriesId: series.id);
}
