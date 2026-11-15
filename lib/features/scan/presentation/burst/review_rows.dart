import 'package:drift/drift.dart' show TableUpdateQuery;
import 'package:dupe/core/database/database_provider.dart';
import 'package:dupe/features/collection/data/collection_repository.dart';
import 'package:dupe/features/collection/domain/series_matching.dart';
import 'package:dupe/features/scan/data/scan_queue_repository.dart';
import 'package:dupe/features/scan/domain/scan_queue_entry.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'review_rows.g.dart';

/// A queued scan as shown in the review screen.
typedef ReviewRow = ({
  ScanQueueEntry entry,

  /// The ISBN was added meanwhile (edited from the review screen).
  bool inCollection,

  /// Series the volume will be filed in, and whether it will be created.
  String? seriesTitle,
  bool newSeries,
});

/// Re-runs on queue changes and on any write to the items table.
@riverpod
Stream<void> _itemChanges(Ref ref) => ref
    .watch(appDatabaseProvider)
    .tableUpdates(
      TableUpdateQuery.onTable(ref.watch(appDatabaseProvider).itemsTable),
    );

@riverpod
Future<List<ReviewRow>> reviewRows(Ref ref) async {
  ref.watch(_itemChangesProvider);
  final entries = await ref.watch(scanQueueProvider.future);
  final repo = ref.watch(collectionRepositoryProvider);
  final series = await repo.listSeries();
  return [
    for (final entry in entries)
      await () async {
        final m = entry.result;
        final inCollection = await repo.findItemByIsbn(entry.isbn13) != null;
        if (m == null) {
          return (
            entry: entry,
            inCollection: inCollection,
            seriesTitle: null,
            newSeries: false,
          );
        }
        final match = findMatchingSeries(m, series, preferredType: entry.type);
        final candidates = seriesTitleCandidates(m);
        final created = match == null && m.volumeNumber != null
            ? candidates.firstOrNull
            : null;
        return (
          entry: entry,
          inCollection: inCollection,
          seriesTitle: match?.title ?? created,
          newSeries: created != null,
        );
      }(),
  ];
}
