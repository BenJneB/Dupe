import 'package:dupe/features/collection/data/collection_repository.dart';
import 'package:dupe/features/collection/domain/collection_type.dart';
import 'package:dupe/features/collection/domain/item.dart';
import 'package:dupe/features/collection/domain/metadata_mapping.dart';
import 'package:dupe/features/collection/domain/series.dart';
import 'package:dupe/features/collection/domain/series_attachment.dart';
import 'package:dupe/features/collection/domain/series_matching.dart';

typedef ItemDraft = ({Item item, SeriesAttachment attachment});

SeriesAttachment _attachTo(Series? series) =>
    series == null ? SeriesAttachment.none : AttachToSeries(series);

/// Another copy of [source] (other edition): same work, volume and series;
/// edition-specific and personal fields are left empty.
Item newCopy(CollectionRepository repo, Item source) => repo
    .newItem(source.type, volumeNumber: source.volumeNumber)
    .copyWith(
      seriesId: source.seriesId,
      title: source.title,
      authors: source.authors,
      publisher: source.publisher,
      language: source.language,
      description: source.description,
    );

/// Item to edit, or new item draft: attached to [seriesId] when given, or to
/// the series matching the online result [prefill] (auto-attach).
Future<ItemDraft?> loadItemDraft(
  CollectionRepository repo, {
  required CollectionType type,
  String? itemId,
  String? seriesId,
  String? volumeNumber,
  ItemPrefill? prefill,
  String? copyOf,
}) async {
  // The series an item is already in, shown and changeable in the form. A
  // deleted series is left on save; one not synced yet is kept.
  Future<SeriesAttachment> current(Item item) async {
    final id = item.seriesId;
    if (id == null) return SeriesAttachment.none;
    if (await repo.getSeries(id) case final series?) {
      return AttachToSeries(series);
    }
    return await repo.isSeriesDeleted(id)
        ? SeriesAttachment.detached
        : SeriesAttachment.none;
  }

  final source = copyOf == null ? null : await repo.getItem(copyOf);
  if (source != null) {
    final copy = newCopy(repo, source);
    return (item: copy, attachment: await current(copy));
  }
  if (itemId != null) {
    final item = await repo.getItem(itemId);
    return item == null ? null : (item: item, attachment: await current(item));
  }
  var series = seriesId == null ? null : await repo.getSeries(seriesId);
  var attachment = _attachTo(series);
  if (prefill != null && series == null) {
    final metadata = prefill.metadata;
    series = findMatchingSeries(
      metadata,
      await repo.listSeries(),
      preferredType: type,
    );
    final candidates = seriesTitleCandidates(metadata);
    attachment = series != null
        ? AttachToSeries(series)
        : metadata.volumeNumber != null && candidates.isNotEmpty
        ? CreateSeries(candidates.first)
        : SeriesAttachment.none;
  }
  // A matched series dictates the type (scanned from another tab).
  final draft = repo.newItem(
    series?.type ?? type,
    series: series,
    volumeNumber: volumeNumber,
  );
  return (
    item: prefill == null
        ? draft
        : applyMetadata(
            draft,
            prefill,
            seriesTitle: switch (attachment) {
              AttachToSeries(:final series) => series.title,
              CreateSeries(:final title) => title,
              _ => null,
            },
          ),
    attachment: attachment,
  );
}

/// Files [item] as [attachment] says: in its series, out of any series
/// (detach), in a new series created now (proposed title, or one typed by
/// the user), or where it already is.
Future<Item> applyAttachment(
  CollectionRepository repo,
  Item item,
  SeriesAttachment attachment,
) async {
  switch (attachment) {
    case AttachToSeries(:final series):
      return item.copyWith(seriesId: series.id);
    case KeepSeries():
      return item;
    case DetachSeries() || CreateSeries(enabled: false):
      return item.copyWith(seriesId: null);
    case CreateSeries(:final title):
      final series = repo
          .newSeries(item.type)
          .copyWith(
            title: title,
            authors: item.authors,
            publisher: item.publisher,
          );
      await repo.saveSeries(series);
      return item.copyWith(seriesId: series.id);
  }
}
