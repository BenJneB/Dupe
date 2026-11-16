import 'package:dupe/core/logging/app_log.dart';
import 'package:dupe/core/metadata/metadata_providers.dart';
import 'package:dupe/features/collection/data/collection_repository.dart';
import 'package:dupe/features/collection/data/volume_count_check.dart';
import 'package:dupe/features/collection/domain/volume_count.dart';
import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'volume_count_scan.g.dart';

/// Progress and findings of "Vérifier le nombre de tomes" over the whole
/// collection.
@immutable
class VolumeCountScanState {
  const new({
    this.running = false,
    this.done = 0,
    this.total = 0,
    this.failed = 0,
    this.proposals = const [],
    this.finished = false,
  });

  final bool running;
  final int done;

  /// Series to check: manga / comics without total, with an enabled source.
  final int total;
  final int failed;
  final List<VolumeCountProposal> proposals;
  final bool finished;
}

/// Checks, one by one (sources are rate limited), every series whose total
/// is unknown and that has a series source; nothing is saved before the
/// user confirms ([apply]).
@Riverpod(keepAlive: true)
class VolumeCountScan extends _$VolumeCountScan {
  @override
  VolumeCountScanState build() => const VolumeCountScanState();

  Future<void> run() async {
    if (state.running) return;
    final lookup = ref.read(seriesLookupProvider);
    final candidates = [
      for (final s in await ref.read(collectionRepositoryProvider).listSeries())
        if (s.totalVolumes == null && lookup.providerFor(s.type) != null) s,
    ];
    state = VolumeCountScanState(
      running: candidates.isNotEmpty,
      total: candidates.length,
      finished: candidates.isEmpty,
    );
    final proposals = <VolumeCountProposal>[];
    var failed = 0;
    for (final (i, series) in candidates.indexed) {
      try {
        if (await checkVolumeCount(lookup, series) case final p?) {
          proposals.add(p);
        }
      } on Object catch (e) {
        failed++;
        appLog.warning('series', e);
      }
      state = VolumeCountScanState(
        running: i + 1 < candidates.length,
        done: i + 1,
        total: candidates.length,
        failed: failed,
        proposals: List.unmodifiable(proposals),
        finished: i + 1 == candidates.length,
      );
    }
  }

  /// Saves the totals of [selected]; returns how many series changed.
  Future<int> apply(Iterable<VolumeCountProposal> selected) async {
    final repo = ref.read(collectionRepositoryProvider);
    final changed = await repo.inTransaction(() async {
      var changed = 0;
      for (final p in selected) {
        final fresh = await repo.getSeries(p.series.id);
        if (fresh == null || fresh.totalVolumes != null) continue;
        await repo.saveSeries(fresh.copyWith(totalVolumes: p.total));
        changed++;
      }
      return changed;
    });
    state = const VolumeCountScanState();
    return changed;
  }
}
