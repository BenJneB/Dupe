import 'package:dupe/core/database/local_stores.dart';
import 'package:dupe/features/collection/data/collection_repository.dart';
import 'package:dupe/features/collection/domain/collection_type.dart';
import 'package:dupe/features/collection/domain/series.dart';
import 'package:dupe/features/settings/data/starter_data.dart';

/// Version of the starter collection last applied (removals run once).
const _versionKey = 'starter_collection_version';
const _version = 2;

/// Inserts or completes the starter collection; can be run several times.
/// - missing series and books are created;
/// - volumes with an ISBN are added, or their ISBN is set on a copy of the
///   same number added without ISBN (grid, range);
/// - removed series are deleted once, only if still as seeded (no ISBN).
/// Returns the number of changes.
Future<int> seedStarterCollection(
  CollectionRepository repo,
  AppSettingsStore settings,
) async {
  var changes = 0;
  final applied = int.tryParse(await settings.get(_versionKey) ?? '') ?? 1;
  if (applied < _version) {
    for (final removed in removedStarterSeries) {
      final series = await repo.findSeries(removed.type, removed.title);
      if (series == null) continue;
      final items = await repo.listSeriesItems(series.id);
      if (items.any((i) => i.isbn13 != null)) continue;
      await repo.deleteSeries(series.id);
      changes++;
    }
  }
  for (final seed in starterSeries) {
    var series = await repo.findSeries(seed.type, seed.title);
    final created = series == null;
    if (series == null) {
      series = repo
          .newSeries(seed.type)
          .copyWith(
            title: seed.title,
            authors: seed.authors,
            publisher: seed.publisher,
            statusPublication: seed.status,
            totalVolumes: seed.total,
          );
      await repo.saveSeries(series);
      if (seed.ownedUpTo > 0) {
        await repo.addVolumeRange(series, from: 1, to: seed.ownedUpTo);
      }
      changes++;
    }
    changes += await _syncVolumes(repo, series, seed, created: created);
  }
  for (final book in starterBooks) {
    if (await repo.findStandaloneItem(CollectionType.livre, book.title) !=
        null) {
      continue;
    }
    await repo.saveItem(
      repo
          .newItem(CollectionType.livre)
          .copyWith(
            title: book.title,
            authors: book.authors,
            publisher: book.publisher,
            publishDate: book.publishDate,
            isbn13: book.isbn13,
          ),
    );
    changes++;
  }
  await settings.set(_versionKey, '$_version');
  return changes;
}

/// Adds the listed volumes of [seed]. Volumes without ISBN are only added
/// with a new series (nothing to identify them by afterwards).
Future<int> _syncVolumes(
  CollectionRepository repo,
  Series series,
  StarterSeries seed, {
  required bool created,
}) async {
  var changes = 0;
  final items = await repo.listSeriesItems(series.id);
  for (final v in seed.volumes) {
    final isbn = v.isbn13;
    if (isbn == null ? !created : await repo.findItemByIsbn(isbn) != null) {
      continue;
    }
    final blank = isbn == null
        ? null
        : items
              .where((i) => i.volumeNumber == v.number && i.isbn13 == null)
              .firstOrNull;
    if (blank != null) items.remove(blank);
    final item =
        (blank ??
                repo
                    .newItem(seed.type, series: series, volumeNumber: v.number)
                    .copyWith(title: v.title ?? series.title))
            .copyWith(isbn13: isbn, edition: v.edition);
    await repo.saveItem(item);
    changes++;
  }
  return changes;
}
