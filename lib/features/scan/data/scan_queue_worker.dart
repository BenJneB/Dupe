import 'package:dupe/core/metadata/metadata_aggregator.dart';
import 'package:dupe/core/metadata/metadata_providers.dart';
import 'package:dupe/core/metadata/metadata_result.dart';
import 'package:dupe/features/scan/data/scan_queue_repository.dart';
import 'package:dupe/features/scan/domain/scan_queue_entry.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'scan_queue_worker.g.dart';

/// Looks the queued ISBNs up one at a time in the background. Sequential on
/// purpose: the sources are rate limited (PLAN.md §5).
class ScanQueueWorker {
  new(this._queue, this._aggregator);

  final ScanQueueRepository _queue;
  final MetadataAggregator _aggregator;
  Future<void>? _running;

  /// Starts processing if idle; completes when the queue has no pending
  /// entry left.
  Future<void> run() =>
      _running ??= _drain().whenComplete(() => _running = null);

  Future<void> _drain() async {
    while (true) {
      final entry = await _queue.nextPending();
      if (entry == null) return;
      final lookup = await _aggregator.lookupIsbn(entry.isbn13, entry.type);
      final merged = lookup.merged;
      final status = switch (merged) {
        null when lookup.failed.isEmpty => ScanStatus.notFound,
        null => ScanStatus.failed,
        // A source failed (BnF slow or rate limited) and the others give
        // neither series nor volume number: imported as is, the volume
        // would land outside its series (recette: Everdark). Retried.
        MetadataResult(seriesTitle: null, volumeNumber: null)
            when lookup.failed.isNotEmpty =>
          ScanStatus.failed,
        _ => ScanStatus.found,
      };
      await _queue.setResult(entry.id, status, merged);
    }
  }
}

@Riverpod(keepAlive: true)
ScanQueueWorker scanQueueWorker(Ref ref) => ScanQueueWorker(
  ref.watch(scanQueueRepositoryProvider),
  ref.watch(metadataAggregatorProvider),
);
