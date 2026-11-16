import 'package:dupe/core/metadata/metadata_result.dart';
import 'package:dupe/features/collection/data/collection_repository.dart';
import 'package:dupe/features/collection/data/item_drafts.dart';
import 'package:dupe/features/collection/domain/enums.dart';
import 'package:dupe/features/collection/domain/item.dart';
import 'package:dupe/features/collection/domain/item_checks.dart';
import 'package:dupe/features/collection/domain/metadata_mapping.dart';
import 'package:dupe/features/collection/domain/same_volume.dart';
import 'package:dupe/features/scan/data/scan_queue_repository.dart';
import 'package:dupe/features/scan/domain/scan_queue_entry.dart';

/// Adds the found entries to the collection (each volume filed in its
/// series, created if needed), then removes them from the queue. Entries
/// already in the collection are only removed. Returns the number added.
Future<int> importScanQueue(
  CollectionRepository repo,
  ScanQueueRepository queue,
  List<ScanQueueEntry> entries, {
  Ownership ownership = Ownership.possede,
}) => repo.inTransaction(() async {
  var added = 0;
  // Sequential: a series created for one volume is matched by the next ones.
  // One transaction: the review list is recomputed once, not per volume.
  for (final entry in entries) {
    final metadata = entry.result;
    if (entry.status != ScanStatus.found || metadata == null) continue;
    if (await repo.findItemByIsbn(entry.isbn13) == null) {
      final draft = await loadItemDraft(
        repo,
        type: entry.type,
        prefill: (metadata: metadata, ownership: ownership),
      );
      if (draft == null) continue;
      final item = await applyAttachment(repo, draft.item, draft.attachment);
      await repo.saveItem(
        await _emptyCopy(repo, item, metadata, ownership, entry.isbn13) ??
            item.copyWith(isbn13: item.isbn13 ?? entry.isbn13),
      );
      added++;
    }
    await queue.remove(entry.id);
  }
  return added;
});

/// The copy of [item]'s volume added earlier without ISBN (grid, range),
/// given [isbn13] and its empty fields filled from [metadata], as in the
/// store mode; null when there is none (a new copy is created).
Future<Item?> _emptyCopy(
  CollectionRepository repo,
  Item item,
  MetadataResult metadata,
  Ownership ownership,
  String isbn13,
) async {
  final seriesId = item.seriesId;
  if (seriesId == null) return null;
  final empty = copiesOfVolume(
    await repo.listSeriesItems(seriesId),
    item.volumeNumber,
  ).where((i) => i.hasNoIsbn && i.ownership == ownership).firstOrNull;
  if (empty == null) return null;
  final series = await repo.getSeries(seriesId);
  return fillBlanks(
    empty.copyWith(isbn13: isbn13),
    metadata,
    seriesTitle: series?.title ?? item.title,
  );
}
