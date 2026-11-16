import 'package:dupe/core/metadata/metadata_aggregator.dart';
import 'package:dupe/core/metadata/metadata_providers.dart';
import 'package:dupe/core/metadata/metadata_result.dart';
import 'package:dupe/features/collection/data/collection_repository.dart';
import 'package:dupe/features/collection/domain/collection_type.dart';
import 'package:dupe/features/collection/domain/enums.dart';
import 'package:dupe/features/collection/domain/item.dart';
import 'package:dupe/features/collection/domain/metadata_mapping.dart';
import 'package:dupe/features/collection/domain/series.dart';
import 'package:dupe/features/collection/domain/series_matching.dart';
import 'package:dupe/features/collection/domain/volume_number.dart';
import 'package:dupe/features/covers/domain/edition_match.dart';
import 'package:dupe/features/scan/domain/store_check.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'store_checker.g.dart';

/// Store mode: local check first (instant, offline), then an online lookup
/// only to recognise a volume of a series of the collection.
class StoreChecker {
  const new(this._repo, this._aggregator);

  final CollectionRepository _repo;
  final MetadataAggregator _aggregator;

  Stream<StoreCheck> check(String isbn13, CollectionType type) async* {
    final local = await _repo.findItemByIsbn(isbn13);
    if (local != null) {
      yield await _fromItem(local);
      return;
    }
    yield const StoreCheck(verdict: StoreVerdict.unknown, searching: true);

    final lookup = await _aggregator.lookupIsbn(isbn13, type);
    final metadata = lookup.merged;
    if (metadata == null) {
      yield StoreCheck(
        verdict: StoreVerdict.unknown,
        offline: lookup.results.isEmpty && lookup.failed.isNotEmpty,
      );
      return;
    }
    final series = findMatchingSeries(
      metadata,
      await _repo.listSeries(),
      preferredType: type,
    );
    if (series == null) {
      // A standalone book owned in another edition (phase 25): same main
      // title and a common author, both required.
      final other = (await _repo.listStandaloneItems())
          .where(
            (i) => sameStandaloneBook(
              metadata,
              title: i.title,
              authors: i.authors,
            ),
          )
          .firstOrNull;
      yield other == null
          ? StoreCheck(verdict: StoreVerdict.unknown, metadata: metadata)
          : await _fromItem(other, otherEdition: metadata);
      return;
    }
    final items = await _repo.listSeriesItems(series.id);
    final copy = _sameVolume(items, metadata.volumeNumber);
    if (copy != null) {
      // Volume added without ISBN (grid, range, previous volumes): remember
      // the ISBN and fill its empty fields (recette: WARP 1-2 left empty).
      final remember = copy.isbn13 == null;
      final item = remember
          ? fillBlanks(
              copy.copyWith(isbn13: isbn13),
              metadata,
              seriesTitle: series.title,
            )
          : copy;
      if (remember) await _repo.saveItem(item);
      yield await _fromItem(
        item,
        series: series,
        isbnRemembered: remember,
        otherEdition: remember ? null : metadata,
      );
      return;
    }
    yield StoreCheck(
      verdict: StoreVerdict.seriesNotOwned,
      series: series,
      ownedNumbers: _ownedNumbers(items),
      metadata: metadata,
    );
  }

  /// Copy of volume [number] in [items]; an owned copy wins over a wish.
  Item? _sameVolume(List<Item> items, String? number) {
    if (number == null) return null;
    final wanted = VolumeNumber.asInt(number)?.toString() ?? number.trim();
    final copies = items.where(
      (i) =>
          (VolumeNumber.asInt(i.volumeNumber)?.toString() ??
              i.volumeNumber?.trim()) ==
          wanted,
    );
    return copies.where((i) => i.ownership == Ownership.possede).firstOrNull ??
        copies.firstOrNull;
  }

  List<int> _ownedNumbers(List<Item> items) => {
    for (final i in items)
      if (i.ownership == Ownership.possede) ?VolumeNumber.asInt(i.volumeNumber),
  }.toList()..sort();

  Future<StoreCheck> _fromItem(
    Item item, {
    Series? series,
    bool isbnRemembered = false,
    MetadataResult? otherEdition,
  }) async {
    final seriesId = item.seriesId;
    final s =
        series ?? (seriesId == null ? null : await _repo.getSeries(seriesId));
    return StoreCheck(
      verdict: item.ownership == Ownership.possede
          ? StoreVerdict.owned
          : StoreVerdict.wished,
      item: item,
      series: s,
      ownedNumbers: s == null
          ? const []
          : _ownedNumbers(await _repo.listSeriesItems(s.id)),
      isbnRemembered: isbnRemembered,
      metadata: otherEdition,
      otherEdition: otherEdition != null,
    );
  }
}

@riverpod
StoreChecker storeChecker(Ref ref) => StoreChecker(
  ref.watch(collectionRepositoryProvider),
  ref.watch(metadataAggregatorProvider),
);

/// Store-mode result for a scanned ISBN; [type] is the tab scanned from.
@riverpod
Stream<StoreCheck> storeCheck(Ref ref, String isbn13, CollectionType type) =>
    ref.watch(storeCheckerProvider).check(isbn13, type);
