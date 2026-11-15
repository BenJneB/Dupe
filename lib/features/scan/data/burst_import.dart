import 'package:dupe/features/collection/data/collection_repository.dart';
import 'package:dupe/features/collection/data/item_drafts.dart';
import 'package:dupe/features/collection/domain/enums.dart';
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
}) async {
  var added = 0;
  // Sequential: a series created for one volume is matched by the next ones.
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
      await repo.saveItem(item.copyWith(isbn13: item.isbn13 ?? entry.isbn13));
      added++;
    }
    await queue.remove(entry.id);
  }
  return added;
}
