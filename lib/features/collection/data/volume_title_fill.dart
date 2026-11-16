import 'package:drift/drift.dart';
import 'package:dupe/core/database/app_database.dart';
import 'package:dupe/core/database/database_provider.dart';
import 'package:dupe/core/logging/app_log.dart';
import 'package:dupe/core/metadata/metadata_providers.dart';
import 'package:dupe/features/collection/data/collection_repository.dart';
import 'package:dupe/features/collection/domain/item.dart';
import 'package:dupe/features/collection/domain/metadata_mapping.dart';
import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'volume_title_fill.g.dart';

/// Progress of "Compléter les titres des tomes".
@immutable
class TitleFillState {
  const new({
    this.running = false,
    this.done = 0,
    this.total = 0,
    this.found = 0,
  });

  final bool running;
  final int done;
  final int total;
  final int found;

  bool get finished => !running && done == total && done > 0;
}

/// Volumes of a series added before the volume title existed (phase 24):
/// numbered, with an ISBN to look up, and no own title yet.
Future<List<Item>> volumesWithoutTitle(AppDatabase db) =>
    (db.select(db.itemsTable)..where(
          (t) =>
              t.deletedAt.isNull() &
              t.seriesId.isNotNull() &
              t.volumeNumber.isNotNull() &
              t.isbn13.isNotNull() &
              (t.volumeTitle.isNull() | t.volumeTitle.equals('')),
        ))
        .get();

/// Looks the volumes without own title up again by ISBN (answers are often
/// already in the disk cache) and saves the title the sources give; nothing
/// else changes, and a title typed meanwhile is kept.
@Riverpod(keepAlive: true)
class VolumeTitleFill extends _$VolumeTitleFill {
  @override
  TitleFillState build() => const TitleFillState();

  Future<void> run() async {
    if (state.running) return;
    final repo = ref.read(collectionRepositoryProvider);
    final sources = ref.read(metadataAggregatorProvider);
    final items = await volumesWithoutTitle(ref.read(appDatabaseProvider));
    final seriesTitles = {
      for (final s in await repo.listSeries()) s.id: s.title,
    };
    state = TitleFillState(running: items.isNotEmpty, total: items.length);
    var found = 0;
    for (final (i, item) in items.indexed) {
      try {
        final lookup = await sources.lookupIsbn(item.isbn13!, item.type);
        final merged = lookup.merged;
        final title = merged == null
            ? null
            : volumeTitleOf(merged, seriesTitle: seriesTitles[item.seriesId]);
        if (title != null) {
          final fresh = await repo.getItem(item.id);
          if (fresh != null && (fresh.volumeTitle ?? '').trim().isEmpty) {
            await repo.saveItem(fresh.copyWith(volumeTitle: title));
            found++;
          }
        }
      } on Object catch (e) {
        appLog.warning('titles', e);
      } finally {
        state = TitleFillState(
          running: i + 1 < items.length,
          done: i + 1,
          total: items.length,
          found: found,
        );
      }
    }
    appLog.info(
      'titles',
      '$found titre(s) de tome ajouté(s), ${items.length} tomes vérifiés',
    );
  }
}
