import 'package:dupe/features/collection/data/collection_repository.dart';
import 'package:dupe/features/collection/domain/collection_type.dart';
import 'package:dupe/features/collection/domain/item.dart';
import 'package:dupe/features/collection/domain/metadata_mapping.dart';
import 'package:dupe/features/collection/domain/series_attachment.dart';
import 'package:dupe/features/collection/domain/series_matching.dart';

typedef ItemDraft = ({Item item, SeriesAttachment attachment});

const SeriesAttachment _none = SeriesAttachment.none;

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
  // The series an item is already in, shown and changeable in the form.
  Future<SeriesAttachment> current(Item item) async => switch (item.seriesId) {
    final id? => switch (await repo.getSeries(id)) {
      final series? => SeriesAttachment(series: series),
      null => _none,
    },
    null => _none,
  };
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
  var attachment = series == null
      ? SeriesAttachment.none
      : SeriesAttachment(series: series);
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
    item: prefill == null
        ? draft
        : applyMetadata(
            draft,
            prefill,
            seriesTitle: series?.title ?? attachment.newSeriesTitle,
          ),
    attachment: attachment,
  );
}

/// Files [item] as [attachment] says: in its series, in no series, or in a
/// new series created now (proposed title, or one typed by the user).
Future<Item> applyAttachment(
  CollectionRepository repo,
  Item item,
  SeriesAttachment attachment,
) async {
  final title = attachment.newSeriesTitle;
  if (attachment.series case final series?) {
    return item.copyWith(seriesId: series.id);
  }
  if (title == null || !attachment.createNew) {
    return item.copyWith(seriesId: null);
  }
  final series = repo
      .newSeries(item.type)
      .copyWith(title: title, authors: item.authors, publisher: item.publisher);
  await repo.saveSeries(series);
  return item.copyWith(seriesId: series.id);
}
